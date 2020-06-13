async function init(): Promise<void> {
    setInterval(() => console.log('CIAO'), 5_000)
}
init().catch(() => null)
