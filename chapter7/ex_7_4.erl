-module(ex_7_4).

-export([test/0, area/1, perimeter/1]).

-record(circle, {radius}).
-record(rectangle, {length, width}).
-record(triangle, {a, b, c}).

area(Shape) when is_record(Shape, circle) ->
  #circle{radius = Radius} = Shape,
  math:pi() * Radius * Radius;
area(Shape) when is_record(Shape, rectangle) ->
  #rectangle{length = Length, width = Width} = Shape,
  Length * Width;
area(Shape) when is_record(Shape, triangle) ->
  #triangle{a = A,
            b = B,
            c = C} =
    Shape,
  S = perimeter(Shape) / 2,
  math:sqrt(S * (S - A) * (S - B) * (S - C)).

perimeter(Shape) when is_record(Shape, circle) ->
  #circle{radius = Radius} = Shape,
  2 * math:pi() * Radius;
perimeter(Shape) when is_record(Shape, rectangle) ->
  #rectangle{length = Length, width = Width} = Shape,
  2 * (Length + Width);
perimeter(Shape) when is_record(Shape, triangle) ->
  #triangle{a = A,
            b = B,
            c = C} =
    Shape,
  A + B + C.

test() ->
  Circle = #circle{radius = 10},
  Area = math:pi() * 100,
  Area = area(Circle),

  Rectangle = #rectangle{length = 10, width = 5},
  50 = area(Rectangle),

  Triangle =
    #triangle{a = 3,
              b = 4,
              c = 5},
  6.0 = area(Triangle),

  Circle1 = #circle{radius = 10},
  Perimeter = math:pi() * 20,
  Perimeter = perimeter(Circle1),

  Rectangle1 = #rectangle{length = 10, width = 5},
  30 = perimeter(Rectangle1),

  Triangle1 =
    #triangle{a = 5,
              b = 6,
              c = 7},
  18 = perimeter(Triangle1),
  ok.
