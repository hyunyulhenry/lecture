library(keyring)
library(blastula)

# https://www.google.com/account/about/
# [보안 수준이 낮은 앱의 액세스] 허용

create_smtp_creds_key(
  id = "gmail",
  user = "leebisu@gmail.com",
  provider = "gmail"
  , overwrite = TRUE
)

view_credential_keys()  # 확인가능
#------------------#


email <- render_email('email.Rmd')

# https://support.google.com/mail/answer/7126229?hl=ko
# SMTP
# https://accounts.google.com/DisplayUnlockCaptcha

email %>%
  smtp_send(
    from = "leebisu@gmail.net",
    to = "hyunyul.lee@doomoolmori.com",
    subject = "Daily 로그",
    credentials = creds_key("gmail")
  )

# window: https://cran.r-project.org/web/packages/taskscheduleR/vignettes/taskscheduleR.html
# linux: https://github.com/bnosac/cronR

