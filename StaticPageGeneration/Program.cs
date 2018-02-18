using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using Saxon.Api;

namespace StaticPageGeneration
{
    class Program
    {
        static void Main(string[] args)
        {
            string currentDirectory = Path.GetDirectoryName(Assembly.GetEntryAssembly().Location);
            // It is important to have a trailing backslash at the end of our output directory.
            var outputDirectory = Path.GetFullPath(Path.Combine(currentDirectory, @"..\..\..\")) + @"protocol\";
            var templateDirectory = Path.GetFullPath(Path.Combine(currentDirectory, @"..\..\")) + @"Protocol Templates\";
            var xmlPath = templateDirectory + "Messages.xml";
            var transform = new Transform();
            var filelist = Directory.GetFiles(templateDirectory, "*.xsl");

            Console.WriteLine("Starting transforms...");
            foreach (var file in filelist)
            {
                transform.Execute(xmlPath, file, outputDirectory);
            }
            Console.WriteLine("All transforms have finished.");
        }
    }

    public class Transform {

        public void Execute (string xmlFilePath, string xslFilePath, string outputDirectory)
        {
            var xslt = new FileInfo(xslFilePath);
            var input = new FileInfo(xmlFilePath);

            // Compile stylesheet
            var processor = new Processor();
            var compiler = processor.NewXsltCompiler();
            var executable = compiler.Compile(new Uri(xslt.FullName));

            // Do transformation (we can use a null destination since the 
            // templates use xsl:result-document tags to generate output files).
            var destination = new NullDestination();
            using (var inputStream = input.OpenRead())
            {
                var transformer = executable.Load();
                transformer.BaseOutputUri = new Uri(outputDirectory);
                transformer.SetInputStream(inputStream, new Uri(input.DirectoryName));
                transformer.Run(destination);
            }
        }
    }
}
