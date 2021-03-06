exception InvalidQuery of string

exception InvalidResponse of string

let message subtype code number msg =
  {j|SqlCommonError - $subtype ($number) - $code: $msg|j}

module Invalid = struct

  let message subtype code msg = message subtype code "99999" msg

  module Query = struct
    let message code msg = message "InvalidQuery" code msg

    exception IllegalUseOfIn of string

    let illegal_use_of_in = IllegalUseOfIn(
      message
      "ILLEGAL_USE_OF_IN"
      (
        String.concat
        " - "
        [
        "Do not use 'IN' with non-batched operations";
        "use a batch operation instead";
        ]
      )
    )
  end

  module Response = struct
    let message code msg = message "InvalidResponse" code msg

    exception ExpectedSelect of string

    exception ExpectedMutation of string

    let expected_mutation = ExpectedMutation(
      message
      "EXPECTED_MUTATION"
      "Expected a mutation response but received a select response"
    )

    let expected_select = ExpectedSelect(
      message
      "EXPECTED_SELECT"
      "Expected a select response but received a mutation response"
    )

    let expected_select_no_response = ExpectedSelect(
      message
      "EXPECTED_SELECT"
      "Expected a select response but received a nil response"
    )
  end
end
