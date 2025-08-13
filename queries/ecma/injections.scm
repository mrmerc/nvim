; extends
; inherits: ecma

; template: `<vue>`
(pair
  key: ((property_identifier) @_prop
    (#eq? @_prop "template")
  )
  value: ((template_string) @injection.content
    (#offset! @injection.content 0 1 0 -1)
    (#set! injection.include-children)
    (#set! injection.language "vue")
  )
)

; const css = `<css>`
(variable_declarator 
  name: ((identifier) @_indentifier
    (#eq? @_indentifier "css")
  ) 
  value: ((template_string) @injection.content 
    (#offset! @injection.content 0 1 0 -1)
    (#set! injection.include-children)
    (#set! injection.language "css")
  )
)

; fn(/* sql */ `<sql>`)
(call_expression
  arguments: (arguments
    (comment) @injection.language (#offset! @injection.language 0 3 0 -3)
    (template_string) @injection.content
      (#offset! @injection.content 0 1 0 -1)
      (#set! injection.include-children)
  )
 )

