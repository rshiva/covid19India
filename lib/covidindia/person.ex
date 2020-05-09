defmodule CovidIndia.Person do
  # @derive [Poison.Encoder]
  defstruct [:agebracket, :contractedfromwhichpatientsuspected,
            :currentstatus, :dateannounced, :detectedcity, :detecteddistrict,
            :detectedstate, :entryid, :gender, :nationality, :notes,
            :numcases, :patientnumber, :source1, :source2, :source3,
            :statecode, :statepatientnumber, :statuschangedate, :typeoftransmission ]
  use ExConstructor

  # %{
  #   "raw_data" => [
  #     %{
  #       "agebracket" => "",
  #       "contractedfromwhichpatientsuspected" => "",
  #       "currentstatus" => "Hospitalized",
  #       "dateannounced" => "27/04/2020",
  #       "detectedcity" => "",
  #       "detecteddistrict" => "",
  #       "detectedstate" => "West Bengal",
  #       "entryid" => "1",
  #       "gender" => "",
  #       "nationality" => "",
  #       "notes" => "Details awaited",
  #       "numcases" => "38",
  #       "patientnumber" => "27892",
  #       "source1" => "mohfw.gov.in",
  #       "source2" => "",
  #       "source3" => "",
  #       "statecode" => "WB",
  #       "statepatientnumber" => "",
  #       "statuschangedate" => "",
  #       "typeoftransmission" => ""
  #     }}
end
