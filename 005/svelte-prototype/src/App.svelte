<script>
	let board = [...Array(25)].map((value, index) => {
		const x = index % 5;
		const y = Math.floor(index / 5);
		return { x, y, checked: Math.random() < 0.5 };
	});

	function toggleNeighbors(x, y) {
		board = board.map((checkbox) => {
			const xDistance = Math.abs(checkbox.x - x);
			const yDistance = Math.abs(checkbox.y - y);
			const isNeighbor =
				(xDistance === 1 && yDistance === 0) ||
				(xDistance === 0 && yDistance === 1);

			if (isNeighbor) {
				return {
					...checkbox,
					checked: !checkbox.checked,
				};
			} else {
				return checkbox;
			}
		});
	}

	function easyMode() {
		board = board.map((checkbox) => {
			return {
				...checkbox,
				checked:
					(checkbox.x === 1 && checkbox.y === 2) ||
					(checkbox.x === 2 && checkbox.y === 1) ||
					(checkbox.x === 2 && checkbox.y === 2) ||
					(checkbox.x === 2 && checkbox.y === 3) ||
					(checkbox.x === 3 && checkbox.y === 2),
			};
		});
	}
</script>

<style>
	button {
		display: block;
	}

	input {
		margin: 0;
		transform: scale(2);
	}

	label {
		background-color: #fff;
		border: 1px solid #999;
		border-right: none;
		display: inline-block;
		margin: -2px;
		padding: 1.5rem;
		transition: 0.1s ease-in;
	}

	label:hover {
		background-color: #eee;
	}

	/* The hr also counts as a child element.
	Therefore we select every 6th element + 1 */
	label:nth-child(6n + 1) {
		border-right: 1px solid #999;
	}

	hr {
		margin: 0;
		padding: 0;
		visibility: hidden;
	}
</style>

<button on:click={easyMode}>Easy mode</button>

<div id="board" />
{#each board as input, index}
	<label>
		<input
			type="checkbox"
			bind:checked={input.checked}
			on:change={() => {
				const x = index % 5;
				const y = Math.floor(index / 5);
				toggleNeighbors(x, y);
			}} />
	</label>

	{#if index % 5 === 4}
		<hr />
	{/if}
{/each}

{#if board.every((checkbox) => !checkbox.checked)}
	<p>You win!</p>
{:else}
	<p>{board.filter((checkbox) => checkbox.checked).length}/25</p>
{/if}
