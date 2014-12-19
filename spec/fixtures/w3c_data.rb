[
    {
        test_name:          'render valid view of new claim',
        controller:         'claim',
        action:             'new',
        method:             'GET',
    },
    {
        test_name:          'render invalid view of new claim',
        controller:         'claim',
        action:             'submission',
        method:             'POST',
        param_name:         'claim',
        params:             invalid_claim_post_data,
        redirect_path:      '/',
        action_redir_err:   'new'
    },
    {
        test_name:          'render valid view of summary',
        controller:         'claim',
        action:             'submission',
        method:             'POST',
        param_name:         'claim',
        params:             claim_post_data['claim'],
        redirect_path:      '/confirmation',
        action_redir:       'confirmation',
    },
    {
        test_name:          'render view of feedback',
        controller:         'feedback',
        action:             'new',
        method:             'GET',
    },
    {
        test_name:          'render view of callback',
        controller:         'user_callback',
        action:             'new',
        method:             'GET',
    },
    {
        test_name:          'render view of invalid callback',
        controller:         'user_callback',
        action:             'create',
        method:             'POST',
        param_name:         'user_callback',
        params:             { name: '', phone: '', description: '' },
        action_redir_err:   'new',
    },
]
