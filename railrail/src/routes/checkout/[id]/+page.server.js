export async function load({ fetch, params }) {
    const id = params.id;
    console.log('Fetching train data from API...');
    const response = await fetch(`http://localhost:3000/trains/${id}`);
    const train = await response.json();

    if (!train) {
        console.error('Train not found');
        return { status: 404, error: new Error('Train not found') };
    }

    console.log('Train data loaded:', train);
    return { train };
}
