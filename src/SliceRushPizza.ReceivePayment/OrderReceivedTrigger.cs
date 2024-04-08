using System.Threading.Tasks;
using Microsoft.Azure.WebJobs;
using Microsoft.Extensions.Logging;

namespace SliceRushPizza.ReceivePayment;

public class OrderReceivedTrigger
{
    [FunctionName("OrderReceivedTrigger")]
    public async Task RunAsync(
        [ServiceBusTrigger("%NewOrdersTopicName%", "%NewOrdersSubscriptionName%", Connection = "AzureServiceBusOrdersListenConnectionString")] string message,
        ILogger log)
    {
        log.LogInformation($"C# ServiceBus topic trigger function processed message: {message}");
    }
}