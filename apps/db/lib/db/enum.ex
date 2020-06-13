defmodule Db.Enum do
  import EctoEnum

  defenum(UserStatus,
    signed_up: 1,
    verified: 2,
    invited: 3
  )
end
