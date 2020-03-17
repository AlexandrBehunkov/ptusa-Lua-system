--version = 5

-- ----------------------------------------------------------------------------
--���������� ���������������� ���������������� ������� �� ������
--����������������� �������.
function add_functionality( tbl_main, tbl_2 )
    if tbl_main == nil or tbl_2 == nil then
        return
    end

    for field, value in pairs( tbl_2 ) do
        tbl_main[ field ] = value
    end
end
-- ----------------------------------------------------------------------------
--����� ��������������� ������ �� ���������� ���������� �� ���������.
project_tech_object =
    {
    name        = "������",
    n           = 1,
    object_type = 1,
    modes_count = 32,

    timers_count               = 1,
    params_float_count         = 1,
    runtime_params_float_count = 1,
    params_uint_count          = 1,
    runtime_params_uint_count  = 1,

    sys_tech_object = 0,

    name_Lua = "OBJECT",

    idx = 1
    }
-- ----------------------------------------------------------------------------
--�������� ���������� ������, ��� ���� ������� ��������������� ���������
--��������������� ������ �� �++.
function project_tech_object:new( o )


    o = o or {} -- Create table if user does not provide one.
    setmetatable( o, self )
    self.__index = self

    --������� ��������� ������.
    if o.tech_type >= 111 and o.tech_type <= 120 then -- 111 - ������ ����� 112 - ������ ����� � �������� ������� �������� �� ������� ������� 113 - ����� �����������
        o.sys_tech_object = cipline_tech_object( o.name,
        o.n,
        o.tech_type,
        o.name_Lua..self.idx,
        o.modes_count,
        o.timers_count,
        o.params_float_count,
        o.runtime_params_float_count,
        o.params_uint_count,
        o.runtime_params_uint_count )
    else
        o.sys_tech_object = tech_object( o.name,
        o.n,
        o.tech_type,
        o.name_Lua..self.idx,
        o.modes_count,
        o.timers_count,
        o.params_float_count,
        o.runtime_params_float_count,
        o.params_uint_count,
        o.runtime_params_uint_count )
    end

    --������������� ���������� ��� ����������, ��� �������� �������.
    o.rt_par_float = o.sys_tech_object.rt_par_float
    o.par_float = o.sys_tech_object.par_float
    o.rt_par_uint = o.sys_tech_object.rt_par_uint
    o.par_uint = o.sys_tech_object.par_uint
    o.timers = o.sys_tech_object.timers

    --����������� ����������� ��������.
    _G[ o.name_Lua..self.idx ] = o
    _G[ "__"..o.name_Lua..self.idx ] = o

    object_manager:add_object( o )

    o.g_idx = self.idx

    self.idx = self.idx + 1
    return o
end
-- ----------------------------------------------------------------------------
--�������� ��� �������, ��� ������ �� ������, ���������� ���� �� �����������
--����� � ������� (���� main.lua).
function project_tech_object:exec_cmd( cmd )
    return 0
end

function project_tech_object:check_on_mode( mode )
    return 0
end

function project_tech_object:init_mode( mode )
    return 0
end

function project_tech_object:evaluate()
    return 0
end

function project_tech_object:init()
end

function project_tech_object:check_off_mode( mode )
    return 0
end

function project_tech_object:final_mode( mode )
    return 0
end

function project_tech_object:init_params( par )
    return 0
end

function project_tech_object:init_runtime_params( par )
    return 0
end

function project_tech_object:is_check_mode( mode )
    return 1
end

function project_tech_object:on_pause( mode )
    return 0
end

function project_tech_object:on_stop( mode )
    return 0
end

function project_tech_object:on_start( mode )
    return 0
end
-- ----------------------------------------------------------------------------
--�������, ������� �������������� � ������ ��������������� �������
--���������� ���������������� ������� (���������� �� �++).
function project_tech_object:get_modes_count()
    return self.sys_tech_object:get_modes_count()
end

function project_tech_object:get_mode( mode )
    return self.sys_tech_object:get_mode( mode )
end

function project_tech_object:get_operation_state( operation )
    return self.sys_tech_object:get_operation_state( operation )
end

function project_tech_object:set_mode( mode, new_state )
    return self.sys_tech_object:set_mode( mode, new_state )
end

function project_tech_object:exec_cmd( cmd )
    return self.sys_tech_object:exec_cmd( cmd )
end

function project_tech_object:get_modes_manager()
    return self.sys_tech_object:get_modes_manager()
end

function project_tech_object:set_cmd( prop, idx, n )
    return self.sys_tech_object:set_cmd( prop, idx, n )
end

function project_tech_object:set_param( par_id, index, value )
    return self.sys_tech_object:set_param( par_id, index, value )
end

function project_tech_object:set_err_msg( msg, mode, new_mode, msg_type )
    new_mode = new_mode or 0
    msg_type = msg_type or tech_object.ERR_CANT_ON
    return self.sys_tech_object:set_err_msg( msg, mode, new_mode, msg_type )
end

function project_tech_object:get_number()
    return self.sys_tech_object:get_number()
end

function project_tech_object:check_operation_on( operation_n, show_error )
    if show_error == nil then
        return self.sys_tech_object:check_operation_on( operation_n )
    else
        return self.sys_tech_object:check_operation_on( operation_n, show_error )
    end
end
-- ----------------------------------------------------------------------------
--������������� ���� ��������� ���������������� ��������������� ��������
--(��������, ������) ��� ������� �� C++.
object_manager =
    {
    objects = {}, --���������������� ��������������� �������.

    --���������� ����������������� ���������������� �������.
    add_object = function ( self, new_object )
        self.objects[ #self.objects + 1 ] = new_object
    end,

    --��������� ���������� ���������������� ��������������� ��������.
    get_objects_count = function( self )
        return #self.objects
    end,

    --��������� ����������������� ���������������� �������.
    get_object = function( self, object_idx )
        local res = self.objects[ object_idx ]
        if res then
            return self.objects[ object_idx ].sys_tech_object
        else
            return 0
        end
    end
    }
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
--������������� ��������, ���������� � �.�. ��������.
OBJECTS = {}

init_tech_objects = function()

    local process_dev_ex = function( mode, state, step_n, action, devices )

        if devices ~= nil then
            for _, value in pairs( devices ) do
                assert( loadstring( "dev = __"..value ) )( )
                if dev == nil then
                    print( "Error: unknown device '"..value.."' (__"..value..")." )
                    dev = DEVICE( -1 )
                end

                mode[ state ][ step_n ][ action ]:add_dev( dev, 0 )
            end
        end
    end

    local process_seat_ex = function( mode, state, step_n, action, devices, t )

        if devices ~= nil then
            local group = 0
            for _, value in pairs( devices ) do
                for _, value in pairs( value ) do
                    assert( loadstring( "dev = __"..value ) )( )
                    if dev == nil then
                        print( "Error: unknown device '"..value.."' (__"..value..")." )
                        dev = DEVICE( -1 )
                    end

                    mode[ state ][ step_n ][ action ]:add_dev( dev, group, t )
                end
                group = group + 1
            end
        end
    end

    local process_step = function( mode, state_n, step_n, value )

        process_dev_ex(  mode, state_n, step_n, step.A_ON,
            value.opened_devices )
        process_dev_ex(  mode, state_n, step_n, step.A_ON_REVERSE,
            value.opened_reverse_devices )
        process_dev_ex(  mode, state_n, step_n, step.A_OFF,
            value.closed_devices )

        process_seat_ex( mode, state_n, step_n, step.A_UPPER_SEATS_ON,
            value.opened_upper_seat_v, valve.V_UPPER_SEAT )
        process_seat_ex( mode, state_n, step_n, step.A_LOWER_SEATS_ON,
            value.opened_lower_seat_v, valve.V_LOWER_SEAT )

        process_dev_ex(  mode, state_n, step_n, step.A_REQUIRED_FB,
            value.required_FB )

        --������ ��������� DI->DO.
        if value.DI_DO ~= nil then

            local group = 0
            for _, value in pairs( value.DI_DO ) do
                for _, value in pairs( value ) do
                    assert( loadstring( "dev = __"..value ) )( )
                    if dev == nil then
                        print( "Error: unknown device '"..value..
                            "' (__"..value..")." )
                        dev = DEVICE( -1 )
                    end
                    mode[ state_n ][ step_n ][ step.A_DI_DO ]:add_dev(
                        dev, group )
                end

                group = group + 1
            end
        end

        --������ ��������� AI->AO.
        if value.AI_AO ~= nil then

            local group = 0
            for _, value in pairs( value.AI_AO ) do
                for _, value in pairs( value ) do
                    assert( loadstring( "dev = __"..value ) )( )
                    if dev == nil then
                        print( "Error: unknown device '"..value..
                            "' (__"..value..")." )
                        dev = DEVICE( -1 )
                    end
                    mode[ state_n ][ step_n ][ step.A_AI_AO ]:add_dev(
                        dev, group )
                end

                group = group + 1
            end
        end

        --�����.
        if value.wash_data ~= nil then

            for field, value in pairs( value.wash_data ) do

                local group = 2
                if value ~= nil then --������.
                    if field == 'DI' then
                        group = 0
                    elseif field == 'DO' then
                        group = 1
                    elseif field == 'devices' then
                        group = 2
                    elseif field == 'rev_devices' then
                        group = 3
                    elseif field == 'pump_freq' then
                        local step_w = mode[ state_n ][ step_n ][ step.A_WASH ]
                        if step_w.add_param_idx ~= nil then
                            --��������� ������ ��������� ��� �������
                            --������� �������.
                            step_w:add_param_idx( value )
                        end

                        value = {}
                    end

                    for _, value in pairs( value ) do --����������.
                        assert( loadstring( "dev = __"..value ) )( )
                        if dev == nil then
                            print( "Error: unknown device '"..value..
                                "' (__"..value..")." )
                            dev = DEVICE( -1 )
                        end

                        mode[ state_n ][ step_n ][ step.A_WASH ]:add_dev(
                            dev, group )
                    end
                end
            end
        end
    end

    --������ ������� �� ������� � ���� �������:
    --  cmd = V95:set_cmd( "st", 0, 1 )
    --  cmd = OBJECT1:set_cmd( "CMD", 0, 1000 )
    SYSTEM = G_PAC_INFO() --��������� � PAC, ������� ��������� � Lua.
    __SYSTEM = SYSTEM     --��������� � PAC, ������� ��������� � Lua.

    for _, obj_info in ipairs( init_tech_objects_modes() ) do

        local modes_count = 0
        if ( obj_info.modes ~= nil ) then
            modes_count = #obj_info.modes
        end

        local par_float_count = 1
        if type( obj_info.par_float ) == "table" then
            par_float_count = #obj_info.par_float
        end
        local rt_par_float_count = 1
        if type( obj_info.rt_par_float ) == "table" then
            rt_par_float_count = #obj_info.rt_par_float
        end
        local par_uint_count = 1
        if type( obj_info.par_uint ) == "table" then
            par_uint_count = #obj_info.par_uint
        end
        local rt_par_uint_count = 1
        if type( obj_info.rt_par_uint ) == "table" then
            rt_par_uint_count = #obj_info.rt_par_uint
        end

        --������� ��������������� ������.
        local object = project_tech_object:new
            {
            name         = obj_info.name or "������",
            n            = obj_info.n or 1,
            tech_type    = obj_info.tech_type or 1,
            modes_count  = modes_count,
            timers_count = obj_info.timers or 1,

            params_float_count         = par_float_count,
            runtime_params_float_count = rt_par_float_count,
            params_uint_count          = par_uint_count,
            runtime_params_uint_count  = rt_par_uint_count
            }

        --���������.
        object.PAR_FLOAT = {}
        obj_info.par_float = obj_info.par_float or {}
        for field, v in pairs( obj_info.par_float ) do
            --self.PAR_FLOAT.EXAMPLE_NAME_LUA = 1
            object.PAR_FLOAT[ v.nameLua ] = field

            --self.PAR_FLOAT[ 1 ] = 1.2
            object.PAR_FLOAT[ field ] = v.value
        end
        --������������� ����������.
        object.init_params_float = function ( self )
            for field, val in ipairs( self.PAR_FLOAT ) do
                self.par_float[ field ] = val
            end

            self.par_float:save_all()
        end

        object.PAR_UINT = {}
        obj_info.par_uint = obj_info.par_uint or {}
        for field, v in pairs( obj_info.par_uint ) do
            object.PAR_UINT[ v.nameLua ] = field
            object.PAR_UINT[ field ] = v.value
        end
        object.init_params_uint = function ( self )
            for field, val in ipairs( self.PAR_UINT ) do
                self.par_uint[ field ] = val
            end

            self.par_uint:save_all()
        end

        object.RT_PAR_FLOAT = {}
        obj_info.rt_par_float = obj_info.rt_par_float or {}
        for field, v in pairs( obj_info.rt_par_float ) do
            object.RT_PAR_FLOAT[ v.nameLua ] = field
        end
        object.RT_PAR_UINT = {}
        obj_info.rt_par_uint = obj_info.rt_par_uint or {}
        for field, v in pairs( obj_info.rt_par_uint ) do
            object.RT_PAR_UINT[ v.nameLua ] = field
        end

        OBJECTS[ #OBJECTS + 1 ] = object
        local modes_manager = object:get_modes_manager()

        for _, oper_info in ipairs( obj_info.modes ) do

            local operation = modes_manager:add_mode( oper_info.name )

            --�������� � �����������.
            if oper_info.states ~= nil then
                for state_n, state_info in ipairs( oper_info.states ) do

                    process_step( operation, state_n, -1, state_info )

                    --����.
                    if state_info.steps ~= nil then

                        for step_n, step_info in ipairs( state_info.steps ) do
                            local time_param_n = step_info.time_param_n or 0
                            local next_step_n = step_info.next_step_n or 0

                            operation:add_step( step_info.name, next_step_n,
                                time_param_n, state_n )

                            process_step( operation, state_n, step_n, step_info )
                        end
                    end
                end
            end
        end -- for _, oper_info in ipairs( value.modes ) do

    end

    return 0
end

-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
--�������, ����������� ������ ���� � PAC. ��������� �� ����������� ���������
--(�� �++).
function eval()
    for _, obj in pairs( object_manager.objects ) do
        obj:evaluate()
    end

    if user_eval ~= nil then user_eval() end
end
-- ----------------------------------------------------------------------------
--�������, ����������� ���� ��� � PAC.  ��������� �� ����������� ���������
--(�� �++).
function init()
    for _, obj in pairs( object_manager.objects ) do
        obj:init()

        if obj.user_init ~= nil then obj:user_init() end
    end

    if user_init ~= nil then user_init() end
end
