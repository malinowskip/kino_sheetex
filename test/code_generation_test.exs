defmodule CodeGenerationTest do
  use ExUnit.Case

  test "generates code when spreadsheet id and api key provided" do
    generated =
      KinoSheetex.to_source(%{
        form: %{
          "spreadsheet_id" => "123",
          "key_env" => "GOOGLE_SHEETS_API_KEY",
          "output_format" => "rows"
        }
      })

    expected = ~S"""
    Sheetex.fetch_rows!("123", key: System.fetch_env!("LB_" <> "GOOGLE_SHEETS_API_KEY"))
    """

    assert_sources_are_identical(generated, expected)
  end

  test "generates code when spreadsheet id and google application env provided" do
    generated =
      KinoSheetex.to_source(%{
        form: %{
          "spreadsheet_id" => "123",
          "google_application_credentials_env" => "GOOGLE_APPLICATION_CREDENTIALS",
          "output_format" => "rows"
        }
      })

    expected = ~S"""
    Sheetex.fetch_rows!("123",
      oauth_token: KinoSheetex.generate_oauth_token("LB_GOOGLE_APPLICATION_CREDENTIALS")
    )
    """

    assert_sources_are_identical(generated, expected)
  end

  test "assigns result to variable" do
    generated =
      KinoSheetex.to_source(%{
        form: %{
          "spreadsheet_id" => "123",
          "google_application_credentials_env" => "GOOGLE_APPLICATION_CREDENTIALS",
          "result_variable" => "my_var",
          "output_format" => "rows"
        }
      })

    expected = ~S"""
    Sheetex.fetch_rows!("123",
    my_var =
      Sheetex.fetch_rows!("123",
        oauth_token: KinoSheetex.generate_oauth_token("LB_GOOGLE_APPLICATION_CREDENTIALS")
      )
    )
    """

    assert_sources_are_identical(generated, expected)
  end

  test "does not generate code if spreadsheet id is missing" do
    attrs = %{
      form: %{
        "output_format" => "rows",
        "key_env" => "GOOGLE_SHEETS_API_KEY"
      }
    }

    generated = KinoSheetex.to_source(attrs)

    assert generated === ""
  end

  test "does not generate code if authorization credentials are missing" do
    attrs = %{
      form: %{
        "spreadsheet_id" => "123",
        "output_format" => "rows"
      }
    }

    generated = KinoSheetex.to_source(attrs)

    assert generated === ""
  end

  defp assert_sources_are_identical(left, right) do
    String.trim(left) === String.trim(right)
  end
end
