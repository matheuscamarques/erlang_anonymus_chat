document.addEventListener("DOMContentLoaded", function () {
    const EventSource = window.EventSource;
    const eventSource = new EventSource("/events");

    eventSource.addEventListener('received_message', event => {
        console.log(event);
        const from = event.lastEventId;
        const message = document.createElement('p');
        message.innerHTML = `${from}: ${event.data}`;
        document.getElementById('messages').prepend(message);
    });



    const submit = document.getElementById('submit');
    const message = document.getElementById('message');

    submit.addEventListener('click', function (e) {
        e.preventDefault();
        fetch('/message', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                text: message.value
            })
        }).then(response => response.text())
    });

    fetch('/message')
        .then(response => response.json())
        .then(data => {
            data.forEach(receive => {
                const p = document.createElement('p');
                p.innerHTML = `${receive.id}: ${receive.message}`;
                document.getElementById('messages').prepend(p);
            })
        });
});