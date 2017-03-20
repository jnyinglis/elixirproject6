defmodule XML do
    import Record, only: [defrecord: 2, extract: 2]

    defrecord :xmlElement, extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl")
    defrecord :xmlText, extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")

    @doc """
    Given a string, this returns a valid XML document in Erlang xmerl format
    """
    @spec string_to_xml(String.t) :: any()
    def string_to_xml(string) do
       {doc, _} =
            :binary.bin_to_list(string)
            |> :xmerl_scan.string

        doc
    end

    @doc """
    Same as the Erlang library xmerl_xpath except the parameter order has Erlang XML document first
    """
    @spec xpath(nil, any()) :: []
    def xpath(nil, _), do: []

    @spec xpath(any(), String.t) :: any()
    def xpath(doc, path) when is_binary(path) == true do
        :xmerl_xpath.string(to_charlist(path), doc)
    end

    @spec xpath(any(), charlist()) :: any()
    def xpath(doc, path) when is_list(path) == true do
        :xmerl_xpath.string(path, doc)
    end

    @doc """
    """
    @spec select(any(), [String.t | charlist()]) :: any()
    def select(doc, path) do
        xpath(doc, path)
    end

    @doc """
    Return all of the nodes from the Erlang XML document based upon the XPath query
    """
    @spec relation(any(), [String.t | charlist()]) :: any()
    def relation(doc, path) do
        xpath(doc, path)
    end

    @doc """
    Return a streaming function for the nodes from the Erlang XML document
    """
    @spec stream_relation(any(), [String.t | charlist()]) :: any()
    def stream_relation(doc, path) do
        Stream.map(xpath(doc, path), &(&1))
    end

    @doc """
    """
    @spec projection_value([any()], [String.t]) :: any()
    def projection_value(nodes, elements) do
        for node <- nodes do
            for element <- elements do
                [elementnode] =
                    node
                    |> relation(element)
                    |> Enum.take(1)

                text(elementnode)
            end
        end
    end

    @spec stream_projection_value([any()], [String.t]) :: any()
    def stream_projection_value(stream_function, elements) do
        Stream.map(stream_function, fn node ->
            for element <- elements do
                [elementnode] =
                    node
                    |> relation(element)
                    |> Enum.take(1)

                text(elementnode)
            end
        end)
    end

    defp text(node) do
        with [xmlText(value: value)] <- xmlElement(node, :content) do
            List.to_string(value)
        else
            _ -> nil
        end
    end
end