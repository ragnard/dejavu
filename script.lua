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
local threads = {}

function setup(thread)
   thread:set("thread_id", thread_id_counter)
   table.insert(threads, thread)
   -- update all known theads with the latest thread count
   for _, t in ipairs(threads) do
      t:set("thread_count", thread_id_counter)
   end
   thread_id_counter = thread_id_counter + 1
end

function init(args)
   print(string.format("thread %d of %d", thread_id, thread_count))
end

-- function init(args)
--    local path = args[1]
   
--    local usable_record = function(record)
--       return record.method == 'GET'
--    end

--    requests = {}
--    for record in filter(usable_record, access_log.records(path)) do
--       table.insert(requests, wrk.format(record.method, record.path))
--    end
--    request_count = table.getn(requests)
--    --print(string.format("Thread %d loaded %d requests from %s", thread_id, request_count, path))
-- end


-- request = function()
--    if (not request_index || request_index > request_count then request_index = thread_id end
--    r = requests[request_index]
--    print(string.format("thread: %d, index: %d", thread_id, request_index))
--    request_index = request_index + thread_count
--    return r
-- end

