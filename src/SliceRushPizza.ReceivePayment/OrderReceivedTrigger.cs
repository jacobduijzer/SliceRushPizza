using System.Threading.Tasks;
using Microsoft.Azure.WebJobs;
using Microsoft.Extensions.Logging;

namespace SliceRushPizza.ReceivePayment;

public class OrderReceivedTrigger
{
    [FunctionName("OrderReceivedTrigger")]
    public async Task RunAsync([ServiceBusTrigger("%NewOrdersTopicName%", "sub-new-order-processing", Connection = "AzureServiceBusOrdersListenConnectionString")] string mySbMsg,
        ILogger log)
    {
        log.LogInformation($"C# ServiceBus topic trigger function processed message: {mySbMsg}");
        
    }
}