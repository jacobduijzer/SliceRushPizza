using System.Threading.Tasks;
using Microsoft.Azure.WebJobs;
using Microsoft.Extensions.Logging;

namespace SliceRushPizza.ReceivePayment;

public class PaymentReceivedTrigger
{
    [FunctionName("PaymentReceivedTrigger")]
   
    public async Task RunAsync(
        [ServiceBusTrigger("%NewPaymentsTopicName%", "%NewPaymentsSubscriptionName%", Connection = "AzureServiceBusPaymentsListenConnectionString")] string message,
        ILogger log)
    {
        log.LogInformation($"{nameof(PaymentReceivedTrigger)}: {message}");
        
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