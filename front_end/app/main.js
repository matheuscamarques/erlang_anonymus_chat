document.addEventListener("DOMContentLoaded", function () {
    const EventSource = window.EventSource;
    const eventSource = new EventSource("/events");

    eventSource.addEventListener('received_message', event => {
        console.log(event);
        const from = event.lastEventId;
        const message = document.createElement('p');
        message.innerHTML = `<span>${from}:</span> ${event.data}`;
        document.getElementById('messages').appendChild(message);
    });



    const submit = document.getElementById('submit');
    const message = document.getElementById('message');
    message.focus();
    // SET KEY UP EVENT LISTENER
    message.addEventListener('keyup', function (event) {
        if(event.key === 'Enter' || event.keyCode === 13){
            submit.click();
        }
    });


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
        }).then( _ => {
            message.value = '';
        });
    });

    fetch('/message')
        .then(response => response.json())
        .then(data => {
            data.forEach(receive => {
                const p = document.createElement('p');
                p.innerHTML = `<span>${receive.id}:</span> ${receive.message}`;
                document.getElementById('messages').appendChild(p);
            })
        });
});