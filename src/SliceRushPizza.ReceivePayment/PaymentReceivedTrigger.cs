using System.Threading.Tasks;
using Microsoft.Azure.WebJobs;
using Microsoft.Extensions.Logging;

namespace SliceRushPizza.ReceivePayment;

public class PaymentReceivedTrigger
{
    [FunctionName("PaymentReceivedTrigger")]
    // [return: ServiceBus("sbt-slicerushpizza-orders", Connection = "AzureServiceBusOrdersConnectionString")]
    public async Task RunAsync([ServiceBusTrigger("%NewPaymentsTopicName%", "%NewPaymentsSubscriptionName%", Connection = "AzureServiceBusPaymentsListenConnectionString")] string message,
        ILogger log)
    {
        log.LogInformation($"C# ServiceBus topic trigger function processed message: {message}");
        
        // var options = new JsonSerializerOptions
        // {
        //     Converters = { new JsonStringEnumConverter(allowIntegerValues : true) },
        // };
        //
        // Payment payment = JsonSerializer.Deserialize<Payment>(message, options);
        //
        // return payment.Order;
    }
}