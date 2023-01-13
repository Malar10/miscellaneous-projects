const { SlashCommandBuilder } = require('@discordjs/builders');

module.exports = {
	data: new SlashCommandBuilder()
		.setName('sussify')
		.setDescription('Makes a number sus')
		.addIntegerOption(option =>
			option.setName('number')
				.setDescription('The number you want to convert')
				.setRequired(true)),

	async execute(interaction) {
		const number = interaction.options.getInteger('number').toString();
        const sus_numbers = ["<:s0:1042152288837451866>", "<:s1:1042152359574392873>", "<:s2:1042152361969336380>", "<:s3:1042152364674658425>", "<:s4:1042152366494978208>", "<:s5:1042152367971389510>", "<:s6:1042152369749770310>", "<:s7:1042152371284873277>", "<:s8:1042152373155541112>", "<:s9:1042152465165987911>"]
        let sussified = "";
        
        for (let i = 0; i < number.length; i++) {
            const digit = Number(number[i])
            sussified += sus_numbers[digit]
        }

		await interaction.reply(sussified);
	},
};