<script>
    export let train;

    function bookTrain() {
        window.location.href = `/checkout/${train.id}`;
    }
</script>

<body>
    <div class="container">
        <div class="train-card">
            <div class="train-details">
                <h3>{train.name} ({train.number})</h3>
                <div class="from-to">
                    <div class="">
                        <p>From : {train.from}</p>
                        <p>{train.arrival}</p>
                    </div>
                    
                    <div class="to">
                        <p>To : {train.to}</p>
                        <p>{train.departure}</p>
                    </div>
                </div>
                <p>Duration: {train.duration}</p>
            </div>
            <div class="booking-info">
                <div class="tickets-left">
                    <p>Tickets Left: {train.ticketsLeft}</p>
                </div>
                <div class="price">
                    <p>Price: ฿{train.price}</p>
                </div>
                <button on:click={bookTrain}>Book Now</button>
            </div>
        </div>
    </div>
</body>

<style>
    body {
        margin: 0;
        padding: 0;
        font-family: 'Open Sans', sans-serif;
        background-color: none;
        display: flex;
        justify-content: center;
        align-items: center;
    }

    .container {
        max-width: 800px;
        width: 100%;
        margin: 0 auto;
        padding: 20px;
    }

    .train-card {
        background-color: #fff;
        border-radius: 5px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 20px;
        max-width: 100vh;
    }

    .train-details {
        flex: 1;
    }

    .train-details h3 {
        margin-top: 0;
        margin-bottom: 10px;
        font-size: 24px;
        color: #333;
    }

    .from-to {
        display: flex;
        justify-content: space-between;
    }

    .from-to div {
        flex: 1;
    }

    .from-to p {
        margin-top: 5px;
        font-size: 16px;
        color: #666;
    }

    .to p {
        margin-top: 5px;
    }

    .booking-info {
        display: flex;
        flex-direction: column;
        align-items: flex-end;
    }

    .tickets-left,
    .price {
        margin-bottom: 10px;
    }

    .tickets-left p,
    .price p {
        margin: 5px 0;
        font-size: 16px;
        color: #666;
    }

    button {
        padding: 10px 20px;
        background-color: #007bff;
        color: #fff;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        outline: none;
        transition: background-color 0.3s;
    }

    button:hover {
        background-color: #0056b3;
    }
</style>
