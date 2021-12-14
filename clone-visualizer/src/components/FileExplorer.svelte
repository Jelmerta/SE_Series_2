<script>
    import {onMount} from "svelte";
    import * as duplicates from '../../data/example.json';
    import Modal from "./Modal.svelte";

    let filesArray = [];

    let active = false;
    let data;

    onMount(() => {
        duplicates.default.map(duplication => {
            duplication.cloneClass.duplications.map(source => {
                let fileName = source.duplication.location.match(/\|(.*)\|/).pop();

                let existsFile = filesArray.find(fileInArray => fileInArray.file === fileName);

                if (existsFile) {
                    const index = filesArray.indexOf(existsFile);

                    if (index > -1) {
                        filesArray.splice(index, 1);
                    }

                    existsFile.meta = [...existsFile.meta, source.duplication];
                    existsFile.count += 1;

                    filesArray = [...filesArray, existsFile];
                } else {
                    let newFile = {
                        "file": fileName,
                        "meta": [source.duplication],
                        "count": 1
                    }

                    filesArray = [...filesArray, newFile];
                }
            })
        });

        filesArray.sort((a, b) => (a.file > b.file) ? 1 : ((b.file > a.file) ? -1 : 0));
    });

    const showModal = meta => {
        data = meta;
        active = !active;
    }
</script>

{#each filesArray as file, i}
    <div class="tile is-parent is-12 notification is-info">
        <div class="columns">
            <div class="column">
                <a on:click={() => showModal(file.meta)}>{file.file}</a>
            </div>
            <div class="column">
                # of duplicates in file: {file.count}
            </div>
        </div>
    </div>
{/each}

<Modal {active} {data}/>