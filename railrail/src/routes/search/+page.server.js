export async function load({ fetch, url }) {
    const from = url.searchParams.get('from') || '';
    const to = url.searchParams.get('to') || '';
    const date = url.searchParams.get('date') || '';

    if (!from || !to || !date) {
        return { selectedTrain: null };
    }

    const response = await fetch(`http://localhost:3000/trains?from=${from}&to=${to}&date=${date}`);
    const allTrains = await response.json();
    const selectedTrain = allTrains.find(train => train.from === from && train.to === to && train.date === date);

    console.log('All Trains:', allTrains); 
    console.log('Selected Train:', selectedTrain); 

    return { selectedTrain };
}
