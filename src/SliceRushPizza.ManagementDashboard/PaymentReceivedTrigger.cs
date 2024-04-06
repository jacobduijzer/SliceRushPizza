using System;
using System.Text.Json;
using System.Text.Json.Serialization;
using Microsoft.Azure.WebJobs;
using Microsoft.Extensions.Logging;
using SliceRushPizza.Domain;

namespace SliceRushPizza.ManagementDashboard;

public class PaymentReceivedTrigger
{
    [FunctionName("PaymentReceivedTrigger")]
    public void Run(
        [ServiceBusTrigger("sbt-slicerushpizza-payments", "sub-slicerushpizza-payments-management-dashboard",
            Connection = "AzureServiceBusPaymentsManagementConnectionString")]
        string message,
        [CosmosDB("db-slicerushpizza", "management", Connection = "AzureCosmosDbConnectionString", PartitionKey = "/Date")] out OrderDocument outputDocument,
        ILogger log)
    {
        log.LogInformation($"C# ServiceBus topic trigger function processed message: {message}");

        var options = new JsonSerializerOptions
        {
            Converters = { new JsonStringEnumConverter(allowIntegerValues: true) },
        };

        Payment payment = JsonSerializer.Deserialize<Payment>(message, options);

        try
        {
            var document = new OrderDocument
            {
                Id = Guid.NewGuid().ToString(),
                OrderId = payment.Order.OrderNumber,
                OrderTotal = payment.Order.OrderTotal.ToString()
            };

            outputDocument = document;
        }
        catch (Exception e)
        {
            Console.WriteLine(e);
            throw;
        }
    }
}