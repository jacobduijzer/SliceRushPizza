using System.Threading.Tasks;
using Microsoft.Azure.WebJobs;
using Microsoft.Extensions.Logging;

namespace SliceRushPizza.ReceivePayment;

public static class OrderReceivedTrigger
{
    [FunctionName("OrderReceivedTrigger")]
    public static async Task RunAsync([ServiceBusTrigger("sbt-slicerushpizza-orders", "sub-slicerushpizza-orders", Connection = "AzureServiceBusOrdersListenConnectionString")] string mySbMsg,
        ILogger log)
    {
        log.LogInformation($"C# ServiceBus topic trigger function processed message: {mySbMsg}");
        
    }
}