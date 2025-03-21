<script>
    import { onMount } from 'svelte';
    import { page } from '$app/stores';

    export let data;
    let train = data.train;
    let name = '';
    let contact = '';
    
    let seatNumber = Math.floor(Math.random() * 100) + 1; 

    async function confirmBooking() {
        seatNumber = Math.floor(Math.random() * 100) + 1;
        console.log('Confirming booking...');

        const booking = {
            trainId: train.id,
            name,
            contact,
            from: train.from,
            to: train.to,
            seatNumber
        };

        console.log('Booking details:', booking);

        await fetch('http://localhost:3000/bookings', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(booking)
        });

        console.log('Booking request sent...');

        await fetch(`http://localhost:3000/trains/${train.id}`, {
            method: 'PATCH',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ ticketsLeft: train.ticketsLeft - 1 })
        });

        console.log('Train tickets updated...');

        alert('Booking confirmed');
        window.location.href = '/history';
    }
</script>



<body>
    <div class="container">
        <div class="train-details">
            <h2>Checkout</h2>
            <p><strong>Train:</strong> {train.name} ({train.number})</p>
            <p><strong>From:</strong> {train.from}</p>
            <p><strong>To:</strong> {train.to}</p>
            <p><strong>Departure:</strong> {train.departure}</p>
            <p><strong>Arrival:</strong> {train.arrival}</p>
            <p><strong>Duration:</strong> {train.duration}</p>
            <p><strong>Tickets Left:</strong> {train.ticketsLeft}</p>
            <p><strong>Price:</strong> ฿{train.price}</p>
        </div>

        <form on:submit|preventDefault={confirmBooking}>
            <div class="form-group">
                <label for="name">Name</label>
                <input type="text" id="name" bind:value={name} placeholder="Enter Your Name" required>
            </div>
            <div class="form-group">
                <label for="contact">Phone Number</label>
                <input type="text" id="contact" bind:value={contact} placeholder="Enter Your Phone Number" required>
            </div>
            <p><strong>Seat Number:</strong> {seatNumber}</p>
            <button type="submit">Confirm Booking</button>
        </form>
    </div>
</body>

<style>
    body {
        font-family: 'Open Sans', sans-serif;
        color: #333;
        margin: 0;
        padding: 20px;
        background-color: #CCC5B9;
    }
    .container {
        max-width: 600px;
        margin: 0 auto;
        padding: 20px;
    }
    h2 {
        text-align: center;
        color: #EB5E28;
        margin-bottom: 20px;
    }
    .train-details {
        background-color: #fff;
        border-radius: 8px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        padding: 20px;
        margin-bottom: 20px;
    }
    .train-details p {
        margin: 10px 0;
    }
    form {
        background-color: #fff;
        border-radius: 8px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        padding: 20px;
    }
    .form-group {
        margin-bottom: 15px;
    }
    label {
        display: block;
        margin-bottom: 5px;
        color: #555;
    }
    input[type="text"] {
        width: calc(100% - 25px); 
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 4px;
        font-size: 16px;
    }
    button {
        width: 100%;
        padding: 10px;
        background-color: #EB5E28;
        color: #fff;
        border: none;
        border-radius: 4px;
        font-size: 16px;
        cursor: pointer;
    }
    button:hover {
        background-color: #D94F1A;
    }
</style>
