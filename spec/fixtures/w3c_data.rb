[
    {
        test_name:          'Render valid view of new claim',
        controller:         'claim',
        action:             'new',
        method:             'GET',
    },
    {
        test_name:          'Render invalid view of new claim',
        controller:         'claim',
        action:             'confirmation',
        action_redir:       'new',
        redirect_path:      '/',
        object_empty:       'claim',
        method:             'GET',
    }
]
