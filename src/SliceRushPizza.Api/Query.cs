using SliceRushPizza.Domain;

namespace SliceRushPizza.Api;

public class Query
{
    public PizzaDto GetPizza() =>
        new PizzaDto
        {
            PizzaId = Guid.NewGuid().ToString(),
            Name = "Triple Meat Deluxe pizza",
            Price = 15
        };
}