-- Copyright The Mumble Developers. All rights reserved.
-- Use of this source code is governed by a BSD-style license
-- that can be found in the LICENSE file at the root of the
-- Mumble source tree or at <https://www.mumble.info/LICENSE>.
--
local xml2lua = require "xml2lua"
local xmlhandler = require "xmlhandler.tree"

local xmlutils = {}

function xmlutils.get_root(xml)
	-- Note: it is important to always create a new handler to avoid issues due to
	-- concurent use of the same handler in multiple concurrent accesses to this function
	-- Solution taken from
	-- https://github.com/manoelcampos/xml2lua/issues/92#issuecomment-1843106426
	local tree = xmlhandler:new()
	local xmlparser = xml2lua.parser(tree)
	xmlparser:parse(xml, WS_NORMALIZE)
	return tree.root
end

function xmlutils.get_value(key, xml)
	if type(xml[key]) == "string" then
		-- Single instance.
		return xml[key]
	elseif type(xml[key]) == "table" then
		if #xml[key] > 0 then
			-- Multiple instances, choose first one.
			return xml[key][1]
		else
			return nil
		end
	end

	return nil
end

return xmlutils
