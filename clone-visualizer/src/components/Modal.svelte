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
                <article class="panel is-warning">
                    <p class="panel-heading">
                        {d.cloneClassName}
                    </p>
                    <div class="panel-block">
                        <p class="subtitle">Amount of line duplicated: {d.amountOfLines}</p>
                    </div>
                    <div class="panel-block">
                        <table class="table is-striped">
                            <thead>
                            <tr>
                                <th>Line Number</th>
                                <th>Line of Code</th>
                            </tr>
                            </thead>
                            <tbody>
                            {#each d.sourceCodeTable as code}
                                <tr>
                                    <td>{code[0]}</td>
                                    <td>{code[1]}</td>
                                </tr>
                            {/each}
                            </tbody>
                        </table>
                    </div>
                </article>
            {/each}
        </section>
    </div>
</div>

<style>
    .modal-card {
        width: 80vw;
    }
</style>