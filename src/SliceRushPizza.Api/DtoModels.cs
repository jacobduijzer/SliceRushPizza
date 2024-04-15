namespace SliceRushPizza.Api;

public class PizzaDto
{
    public string PizzaId { get; set; }
    public string Name { get; set; }
    public decimal Price { get; set; }
}

public class OrderDto
{
    public string OrderNumber { get; set; }
    public List<OrderLineDto> OrderLines { get; set; }
}

public class OrderLineDto
{
    public PizzaDto Pizza { get; set; }
    public int Amount { get; set; }
}