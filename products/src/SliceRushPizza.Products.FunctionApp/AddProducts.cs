using System;
using Microsoft.Azure.WebJobs;
using Microsoft.Extensions.Logging;

namespace SliceRushPizza.Products.FunctionApp;

public static class AddProducts
{
   
    [FunctionName("AddProducts")]
    [return: Table("products", Connection = "AzureWebJobsStorage")]
    public static Product TableOutput([HttpTrigger] dynamic input, ILogger log)
    {
        log.LogInformation($"C# http trigger function processed: {input.Name}");
        var product = new Product
        {
            PartitionKey = input.ProductType,
            RowKey = Guid.NewGuid().ToString(),
            Name = input.Name,
            Price = input.Price
        };
    
        return product;
    }
}