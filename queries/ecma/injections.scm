; extends
; inherits: ecma

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

