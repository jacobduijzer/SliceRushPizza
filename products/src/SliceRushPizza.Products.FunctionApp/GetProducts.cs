using System.Threading.Tasks;
using Azure;
using Azure.Data.Tables;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;

namespace SliceRushPizza.Products.FunctionApp;

public static class GetProducts
{
    // [FunctionName("GetProducts")]
    // // [TableOutput("OutputTable", Connection = "AzureWebJobsStorage")]
    // public static async Task<IActionResult> RunAsync(
    //     [HttpTrigger(AuthorizationLevel.Function, "get", "post", Route = null)] HttpRequest req, ILogger log)
    // {
    //     log.LogInformation("C# HTTP trigger function processed a request.");
    //
    //     string name = req.Query["name"];
    //
    //     string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
    //     dynamic data = JsonConvert.DeserializeObject(requestBody);
    //     name = name ?? data?.name;
    //
    //     return name != null
    //         ? (ActionResult)new OkObjectResult($"Hello, {name}")
    //         : new BadRequestObjectResult("Please pass a name on the query string or in the request body");
    //     
    // }
    
    // [FunctionName("GetProducts")]
    // public static void Run(
    //     [HttpTrigger(AuthorizationLevel.Function, "get", "post", Route = null)] HttpRequest req,
    //     // [Table("products")] IQueryable<Product> products, ILogger log)
    // {
    //     foreach (Product product in products)
    //     {
    //         log.LogInformation($"PK={product.PartitionKey}, RK={product.RowKey}, Name={product.Name}");
    //     }
    // }
    
    [FunctionName("GetProducts")]
    public static async Task<IActionResult> RunAsync(
        [HttpTrigger(AuthorizationLevel.Anonymous, "get")] HttpRequest req,
        [Table("products")] TableClient tableClient,
        ILogger log)
    {
        var filter = req.Query["productType"];
        AsyncPageable<Product> queryResults = tableClient.QueryAsync<Product>(filter: $"PartitionKey eq '{filter}'");
        return new OkObjectResult(queryResults);
    }

}