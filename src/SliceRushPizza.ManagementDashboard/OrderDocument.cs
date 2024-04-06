using System;
using System.Text.Json.Serialization;

namespace SliceRushPizza.ManagementDashboard;

public class OrderDocument
{
    [JsonPropertyName("id")]
    public string Id { get; set; }
    [JsonPropertyName("date")]
    public string Date { get; set; } = DateTime.Now.ToString(); 
    public string OrderId { get; set; }
    public string OrderTotal { get; set; }
}