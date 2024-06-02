defmodule A11yAudit.Assertions do
  @moduledoc "ExUnit assertions"

  alias A11yAudit.Formatter
  alias A11yAudit.Results

  @type opts ::
          [
            violations_print_limit: integer | :infinity,
            nodes_per_violation_print_limit: integer | :infinity,
            node_html_print_limit: integer | :infinity
          ]

  @doc """
  ## Options

  - `:violations_print_limit` - The maximum number of violations that will be printed in the error when the assertion fails. Can be an integer or `:infinity`. Defaults to `:infinity`.
  - `:nodes_per_violation_print_limit` - The maximum number of nodes that will be printed for each violation when the assertion fails. Can be an integer or `:infinity`. Defaults to 5.
  - `:node_html_print_limit` - The maximum length of the HTML snippet that will be printed for each node when the assertion fails. Can be an integer or `:infinity`. Defaults to 100.
  """
  @spec assert_no_violations(Results.t(), opts()) :: nil | no_return
  def assert_no_violations(results, opts \\ []) do
    opts = Keyword.merge(default_opts(), opts)

    violations_count = Enum.count(results.violations)

    if violations_count > 0 do
      noun = if violations_count == 1, do: "violation", else: "violations"

      error_message =
        "Expected page to have no accessibility violations, but got #{Enum.count(results.violations)} #{noun}.\n\n"

      error_message = error_message <> Formatter.format_results(results, opts)

      raise ExUnit.AssertionError,
        message: error_message
    end
  end

  @doc false
  def default_opts() do
    [
      violations_print_limit: :infinity,
      nodes_per_violation_print_limit: 5,
      node_html_print_limit: 100
    ]
  end
end
