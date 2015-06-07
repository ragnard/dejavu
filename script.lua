--
-- dejavu
--

----------------------------------------------------------------------
-- functional   

function map(f, iter)
   return function()
      local v = iter()
      if v then
         return f(v)
      end
   end
end

function filter(f, iter)
   return function()
      while true do
         local v = iter()
         if not v then break end
         if f(v) then return v end
      end
   end
end

function indexer()
   local i = 0
   return function(v) 
      i = i + 1
      return i, v
   end
end

----------------------------------------------------------------------
-- elb acess log parsing

local access_log = {}

function access_log.parse_log_line(line)
   local record = {}
   for idx, field in map(indexer(), line:gmatch('%S+')) do
      if idx == 1 then
         record.timestamp = field
      elseif idx == 12 then
         record.method = field:sub(2)
      elseif idx == 13 then
         record.path = field
      end
   end
   return record
end

function access_log.records(path)
   return map(access_log.parse_log_line, io.lines(path))
end


----------------------------------------------------------------------
-- wrk script

local thread_id_counter = 1

function setup(thread)
   thread:set("thread_id", thread_id_counter)
   thread_id_counter = thread_id_counter + 1
end

function init(args)
   local path = args[1]

   local usable_record = function(record)
      return record.method == 'GET'
   end

   requests = {}
   for record in filter(usable_record, access_log.records(path)) do
      table.insert(requests, wrk.format(record.method, record.path))
   end
   request_count = table.getn(requests)
   request_index = 0
   print(string.format("Thread %d loaded %d requests from %s", thread_id, request_count, path))
end

function request()
   request_index = (request_index + 1) % request_count
   return requests[request_index]
end
