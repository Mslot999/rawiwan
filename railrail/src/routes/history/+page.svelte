<script>
    import { onMount } from 'svelte';

    let bookingList = [];
    let searchName = '';
    let filteredBookingList = [];

    onMount(async () => {
        const response = await fetch('http://localhost:3000/bookings');
        bookingList = await response.json();
        console.log('Booking list:', bookingList); 
    });

    async function searchBookings() {
        filteredBookingList = searchName 
            ? bookingList.filter(b => b.name.toLowerCase().includes(searchName.toLowerCase())) 
            : [];
        console.log('Filtered booking list:', filteredBookingList); 
    }

    async function cancelBooking(id) {
        // ดึงการจองที่เกี่ยวข้องเพื่อดึง trainId
        const booking = bookingList.find(b => b.id === id);
        console.log('Cancelled booking:', booking); 

        // ลบการจอง
        await fetch(`http://localhost:3000/bookings/${id}`, {
            method: 'DELETE'
        });
        bookingList = bookingList.filter(b => b.id !== id);
        console.log('Updated booking list:', bookingList); 

        // ปรับยอดจำนวนตั๋วที่เหลือ
        const trainResponse = await fetch(`http://localhost:3000/trains/${booking.trainId}`);
        const train = await trainResponse.json();
        const updatedTicketsLeft = train.ticketsLeft + 1;

        await fetch(`http://localhost:3000/trains/${booking.trainId}`, {
            method: 'PATCH',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ ticketsLeft: updatedTicketsLeft }),
        });

        alert('Booking cancelled');
        searchBookings();
    }
</script>



<body>
    <div class="container-flex">
        <h2>Booking History</h2>
        <form on:submit|preventDefault={searchBookings}>
            <input type="text" bind:value={searchName} placeholder="Enter Your Name" required />
            <button type="submit">Search</button>
        </form>

        {#if filteredBookingList.length > 0}
            <ul>
                {#each filteredBookingList as booking}
                    <li>
                        <p>Train: {booking.trainId}</p>
                        <p>From: {booking.from}</p>
                        <p>To: {booking.to}</p>          
                        <p>Name: {booking.name}</p>
                        <p>Contact: {booking.contact}</p>
                        <p>Seat Number: {booking.seatNumber}</p>
                        <button on:click={() => cancelBooking(booking.id)}>Cancel</button>
                    </li>
                {/each}
            </ul>
        {:else if searchName}
            <p>No bookings found.</p>
        {/if}
    </div>
</body>

<style>
    body{
        display: flex;
        justify-content: space-around;
        margin: 20px;
    }
    .container-flex{
        justify-content: space-around;
        width: 70%;
        background: #403D39;
        color: #FFFCF2;
        
        border-radius: 20px;
        padding: 30px 40px;
    }
    form {
        display: flex;
        justify-content: space-around;

    }

    ul {
        list-style: none;
        padding: 0;
        color: #252422;
        justify-content: space-around;
    }

    li {
        border: none;
        padding: 1rem;
        margin-bottom: 1rem;
        background-color: #FFFCF2;
        justify-content: space-around;


    }

    input {
        padding: 0.5rem;
        border: none;
        border-radius: none;
        width: 100%;
    }

    button {
        padding: 0.5rem 1rem;
        background-color: #EB5E28;
        color: #FFFCF2;
        border: none;
        border-radius: none;
        cursor: pointer;
        transition: background-color 0.3s;

    }

    button:hover {
        background-color: #3c6e71;
    }
</style>