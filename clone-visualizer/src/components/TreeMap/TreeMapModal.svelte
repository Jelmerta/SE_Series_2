<script>
    export let active = false;
    export let data = [];

    const closeModal = () => {
        data = "";
        active = !active;
    }
</script>

<div class="modal {active ? 'is-active' : ''}">
    <div class="modal-background"></div>
    <div class="modal-card">
        <header class="modal-card-head">
            <p class="modal-card-title">Occurences</p>
            <button class="delete" aria-label="close" on:click={() => closeModal()}></button>
        </header>
        <section class="modal-card-body">
            {#each data as d}
                <div>
                    <span>
                        <b>File name:</b> {d.data.name}
                    </span>
                    <br/>
                    <span>
                        <b>Amount of duplicated lines:</b> {d.data.value}
                    </span>
                </div>
                <div>
                    <b>On the following line numbers:</b>
                    {#each d.data.lines as ln}
                        <span>{ln}, </span>
                    {/each}
                </div>
                <div>
                    <b>With the following code:</b>
                    <br/>
                    {#each d.data.code as c}
                        <span>{c}</span>
                        <br/>
                    {/each}
                </div>
                <br/>
            {/each}
        </section>
    </div>
</div>

<style>
    .modal-card {
        width: 80vw;
    }
</style>