; Aerial symbol outline for Dockerfiles.
; Shows build stages (FROM) and major instructions (RUN, COPY, ENV, etc.).

; Build stages: FROM <image> [AS <alias>]
(from_instruction
  (image_spec
    (image_name) @name)
  (#set! "kind" "Module")) @symbol

; RUN -- first shell fragment as name
(run_instruction
  (shell_command
    (shell_fragment) @name)
  (#set! "kind" "Method")) @symbol

; COPY / ADD -- first path as name
(copy_instruction
  (path) @name
  (#set! "kind" "Method")) @symbol

(add_instruction
  (path) @name
  (#set! "kind" "Method")) @symbol

; WORKDIR -- path as name
(workdir_instruction
  (path) @name
  (#set! "kind" "Method")) @symbol

; ENV -- first pair key as name
(env_instruction
  (env_pair
    (string) @name)
  (#set! "kind" "Method")) @symbol

; ARG -- unquoted string as name
(arg_instruction
  (unquoted_string) @name
  (#set! "kind" "Method")) @symbol

; Remaining instructions -- node text as name
(cmd_instruction          (#set! "kind" "Method")) @symbol
(entrypoint_instruction   (#set! "kind" "Method")) @symbol
(expose_instruction       (#set! "kind" "Method")) @symbol
(label_instruction        (#set! "kind" "Method")) @symbol
(healthcheck_instruction  (#set! "kind" "Method")) @symbol
(shell_instruction        (#set! "kind" "Method")) @symbol
(user_instruction         (#set! "kind" "Method")) @symbol
(volume_instruction       (#set! "kind" "Method")) @symbol
(onbuild_instruction      (#set! "kind" "Method")) @symbol
(maintainer_instruction   (#set! "kind" "Method")) @symbol
