defmodule Counter.Scene.Home do
  use Scenic.Scene

  alias Scenic.Graph

  import Scenic.Components

  @text_size 24

  @impl Scenic.Scene
  def init(_, _opts) do
    graph =
      Graph.build(font: :roboto, font_size: @text_size)
      |> text_field("0", id: :count_text, t: {5, 5}, width: 50)
      |> button("Count", id: :count_button, t: {80, 5})

    state = %{count: 0, graph: graph}

    {:ok, state, push: graph}
  end

  @impl Scenic.Scene
  def filter_event({:click, :count_button}, _from, %{count: count, graph: graph} = state) do
    new_count = count + 1
    new_graph = Graph.modify(graph, :count_text, &text_field(&1, "#{new_count}"))

    {:noreply, %{state | count: new_count, graph: new_graph}, push: new_graph}
  end

  @impl Scenic.Scene
  def handle_input({:key, {"Q", :press, _}}, _context, state) do
    {:halt, state}
  end

  def handle_input(input, _context, state) do
    IO.inspect(input, label: :input)
    {:noreply, state}
  end
end
