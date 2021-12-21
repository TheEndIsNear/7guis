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
      |> button("Inc", id: :inc_button, t: {70, 5}, theme: :success)
      |> button("Dec", id: :dec_button, t: {130, 5}, theme: :success)

    state = %{count: 0, graph: graph}

    {:ok, state, push: graph}
  end

  @impl Scenic.Scene
  def filter_event({:click, :inc_button}, _from,  state) do
    %{graph: new_graph} = new_state = increase_count(state)
    {:noreply, new_state, push: new_graph}
  end

  def filter_event({:click, :dec_button}, _from,  state) do
    %{graph: new_graph} = new_state = decrease_count(state)

    {:noreply, new_state, push: new_graph}
  end


  @impl Scenic.Scene
  def handle_input({:key, {"Q", _, _}}, _context, state) do
    System.stop()
    {:halt, state}
  end

  def handle_input({:key, {"+",  :press, _}}, _context, state) do
    %{graph: new_graph} = new_state = increase_count(state)
    {:noreply, new_state, push: new_graph}
  end

  def handle_input({:key, {"-", :press, _}}, _context, state) do
    %{graph: new_graph} = new_state = decrease_count(state)
    {:noreply, new_state, push: new_graph}
  end

  def handle_input(input, _context, state) do
    IO.inspect(input)
    {:noreply, state}
  end

  defp increase_count(%{count: count, graph: graph} = state) do
    new_count = count + 1
    new_graph = Graph.modify(graph, :count_text, &text_field(&1, "#{new_count}"))
%{state | count: new_count, graph: new_graph}
  end

  defp decrease_count(%{count: count, graph: graph} = state) do
    new_count = count - 1
    new_graph = Graph.modify(graph, :count_text, &text_field(&1, "#{new_count}"))
%{state | count: new_count, graph: new_graph}
  end
end
