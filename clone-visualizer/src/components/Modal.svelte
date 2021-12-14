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
                    <p>{d.location}</p>
                    <p>{d.code}</p>
                </div>
            {/each}
        </section>
    </div>
</div>

<style>
    .modal-card {
        width: 80vw;
    }
</style>