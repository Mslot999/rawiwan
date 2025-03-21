<script>
    import { onMount } from 'svelte';
    import TrainCard from '../../lib/components/TrainCard.svelte';

    let from = '';
    let to = '';
    let date = '';
    let selectedTrain = null; 

    async function searchTrains() {
        const response = await fetch(`http://localhost:3000/trains?from=${from}&to=${to}&date=${date}`);
        const allTrains = await response.json();

        selectedTrain = allTrains.find(train => train.from === from && train.to === to);
        console.log('Selected Train:', selectedTrain); 
    }
</script>



<style> 
    body {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-family: Open Sans, sans-serif;
    }
    .container-fluid {
        max-width: 100%; 
        margin: 0 auto;
        justify-content: space-between;
        align-items: center;

        
    }
    form {
        background-color: #FFFCF2;     
        height: 80px;
        justify-content: space-around;
        align-items: center;
        display: flex;
        
    }
    .input-form {
        display: flex;
        flex-direction: column;
        color: #252422;
    }
    .input-form select {
        background-color: #FFFCF2;
        font-size: 15px;
        height: 40px;
        width: 180px;
        border: none;
        border-bottom: solid 2px #EB5E28;  
        outline: none;  
    }
    .input-form input {
        background-color: #FFFCF2;
        font-size: 15px;
        height: 38px;
        width: 180px;
        border: none;
        border-bottom: solid 2px #EB5E28;  
        outline: none;  
    }
    .input-form input:focus {
        border-bottom: solid 2px #2a9d8f;  
    }
    

    .input-form select:focus {
        border-bottom: solid 2px #2a9d8f;  
    }
    .input-form label{
        font-size: small;
    }
    button{
        width: 100px;
        height: 40px;
        background: #EB5E28;
        color: #FFFCF2;
        border-radius: 5px;
        cursor: pointer;
        outline: none;
        border: none;
        transition: background-color 0.3s;
    }

    button:hover {
        background-color: #3c6e71;
    }
    
</style>
<body>
    <header>
        <div class="container-fluid">
            <form on:submit|preventDefault={searchTrains}>
                <div class="input-form">
                    <label for="from">From</label>
                    <select id="from" name="from" bind:value={from} required>
                        <option disabled selected value="">Please select a station.</option>
                        <option value="BANGKOK">BANGKOK</option>
                        <option value="LOP BURI">LOP BURI</option>
                        <option value="CHIANG MAI">CHIANG MAI</option>
                    </select>
                </div>
                <div class="input-form">
                    <label for="to">To</label>
                    <select id="to" name="to" bind:value={to} required>
                        <option disabled selected value="">Please select a station.</option>
                        <option value="BANGKOK">BANGKOK</option>
                        <option value="LOP BURI">LOP BURI</option>
                        <option value="CHIANG MAI">CHIANG MAI</option>
                    </select>
                </div>              
                <div class="input-form">
                    <label for="date">Departure Date</label>
                    <input type="date" id="date" name="date" bind:value={date} required>
                </div>
                <button type="submit" class="button">Search Tickets</button>

            </form>
            
            
        </div>
        
        
    </header>
    
</body>

{#if selectedTrain}
    <ul>
        <TrainCard train={selectedTrain} />
    </ul>
{/if}
