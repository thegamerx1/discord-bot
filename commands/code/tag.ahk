class command_tag extends DiscoBase.command {
	cooldown := 3
	info := "Does things with tags"
	args := [{name: "tag"}]
	permissions := ["MANAGE_MESSAGES"]
	commands := [{name: "create", args: [{name: "tag"}, {name: "content"}]}
				,{name: "delete", args: [{name: "tag"}]}
				,{name: "list"}
				,{name: "edit", args: [{name: "tag"}, {name: "newcontent"}]}]

	c_create(ctx, args) {
		if this.findTag(ctx, args[1])
			this.except(ctx, "Tag already exists!")

		this.createTag(ctx, args[1], args[2])
		ctx.delete()
		this.this := this
		ctx.reply(new discord.embed(, ctx.getEmoji(this.bot.randomCheck()) " """ args[1] """ succesfully created " ctx.author.mention))
	}

	c_delete(ctx, args) {
		if !(tag := this.findTag(ctx, args[1]))
			this.except(ctx, "Tag not found!")

		if (tag.owner != ctx.author.id)
			this.except(ctx, "You dont have permissions to delete that tag!")

		ctx.guild.data.tags.removeat(tag.index)
		ctx.react(this.bot.randomCheck())
	}

	c_edit(ctx, args) {
		if !(tag := this.findTag(ctx, args[1]))
			this.except(ctx, "Tag not found!")

		if (tag.owner != ctx.author.id)
			this.except(ctx, "You dont have permissions to edit that tag!")

		ctx.guild.data.tags.removeat(tag.index)
		this.createTag(ctx, args[1], args[2])
		ctx.react(this.bot.randomCheck())
	}

	c_list(ctx) {
		out := ""
		for i, tag in ctx.guild.data.tags {
			out .= i " - " tag.name
		}
		ctx.reply(!out ? "No tags" : out)
	}

	call(ctx, args) {
		if !(tag := this.findTag(ctx, args[1]))
			this.except(ctx, "Tag not found!")

		embed := new discord.embed(, tag.content)
		embed.setFooter("Tag created by " ctx.author.get(tag.owner).notMention)
		ctx.reply(embed)
	}

	findTag(ctx, name) {
		for i, tag in ctx.guild.data.tags {
			if (tag.name = name) {
				tag.index := i
				return tag
			}
		}
	}

	createTag(ctx, name, content) {
		ctx.guild.data.tags.push({name: name, content: content, created: ctx.timestamp, owner: ctx.author.id})
	}
}