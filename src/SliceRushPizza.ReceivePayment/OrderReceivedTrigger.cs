using System.Threading.Tasks;
using Microsoft.Azure.WebJobs;
using Microsoft.Extensions.Logging;

namespace SliceRushPizza.ReceivePayment;

public class OrderReceivedTrigger
{
    [FunctionName("OrderReceivedTrigger")]
    [return: ServiceBus("%NewPaymentsTopicName%", Connection = "AzureServiceBusPaymentsSendConnectionString")]
    public async Task<string> RunAsync(
        [ServiceBusTrigger("%NewOrdersTopicName%", "%NewOrdersSubscriptionName%", Connection = "AzureServiceBusOrdersListenConnectionString")] string message,
        ILogger log)
    {
        log.LogInformation($"{nameof(OrderReceivedTrigger)}: {message}");

        return await Task.FromResult(message);
    }
}