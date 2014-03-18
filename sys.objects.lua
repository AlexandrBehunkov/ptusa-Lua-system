--version = 1

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
    if o.tech_type == 111 then -- 111 - ������ �����
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

function project_tech_object:evaluate( par )
    return 0
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
--������������� �������, ���������� � �.�. ��������.
OBJECTS = {}

init_tech_objects = function()

    process_dev = function( mode, step_n, action, devices )
        if devices ~= nil then

            for field, value in pairs( devices ) do
                assert( loadstring( "dev = __"..value ) )( )
                if dev == nil then
                    error( "Unknown device '"..value.."' (__"..value..")." )
                end

                mode[ step_n ][ action ]:add_dev( dev, 0 )
            end
        end
    end

    process_seat = function( mode, step_n, action, devices, t )

        if devices ~= nil then

            local group = 0
            for field, value in pairs( devices ) do
                for field, value in pairs( value ) do
                    assert( loadstring( "dev = __"..value ) )( )
                    if dev == nil then
                        error( "Unknown device '"..value.."' (__"..value..")." )
                    end

                    mode[ step_n ][ action ]:add_dev( dev, group, t )
                end
                group = group + 1
            end
        end
    end

    --������ ������� �� ������� � ���� �������:
    --  cmd = V95:set_cmd( "st", 0, 1 )
    --  cmd = OBJECT1:set_cmd( "CMD", 0, 1000 )
    SYSTEM = G_PAC_INFO() --��������� � PAC, ������� ��������� � Lua.
    __SYSTEM = SYSTEM     --��������� � PAC, ������� ��������� � Lua.

    for fields, value in ipairs( init_tech_objects_modes() ) do

        local modes_count = 0
        if ( value.modes ~= nil ) then
            modes_count = #value.modes
        end

        local par_float_count = 1
        if type( value.par_float ) == "table" then
            par_float_count = #value.par_float
        end
        local rt_par_float_count = 1
        if type( value.rt_par_float ) == "table" then
            rt_par_float_count = #value.rt_par_float
        end
        local par_uint_count = 1
        if type( value.par_uint ) == "table" then
            par_uint_count = #value.par_uint
        end
        local rt_par_uint_count = 1
        if type( value.rt_par_uint ) == "table" then
            rt_par_uint_count = #value.rt_par_uint
        end

        --������� ��������������� ������.
        local object = project_tech_object:new
            {
            name         = value.name or "������",
            n            = value.n or 1,
            tech_type    = value.tech_type or 1,
            modes_count  = modes_count,
            timers_count = value.timers or 1,

            params_float_count         = par_float_count,
            runtime_params_float_count = rt_par_float_count,
            params_uint_count          = par_uint_count,
            runtime_params_uint_count  = rt_par_uint_count
            }

        --���������.
        if value.init_par_float ~= null then
            value.init_par_float( object )
        end
        if value.init_par_uint ~= null then
            value.init_par_uint( object )
        end
        if value.init_rt_par_float ~= null then
            value.init_rt_par_float( object )
        end
        if value.init_rt_par_uint ~= null then
            value.init_rt_par_uint( object )
        end

        local cooper_param_number = value.cooper_param_number or -1

        local modes_manager = object:get_modes_manager()

        for fields, value in ipairs( value.modes ) do

            local mode = modes_manager:add_mode( value.name )
            mode:set_step_cooperate_time_par_n( cooper_param_number )

            process_dev(  mode, -1, step.A_ON,  value.opened_devices )
            process_dev(  mode, -1, step.A_OFF, value.closed_devices )

            process_seat( mode, -1, step.A_UPPER_SEATS_ON,
                value.opened_upper_seat_v, i_mix_proof.ST_UPPER_SEAT )
            process_seat( mode, -1, step.A_LOWER_SEATS_ON,
                value.opened_lower_seat_v, i_mix_proof.ST_LOWER_SEAT )

            process_dev(  mode, -1, step.A_REQUIRED_FB, value.required_FB )

            --������ ��������� DI->DO.
            if value.DI_DO ~= nil then

                local group = 0
                for field, value in pairs( value.DI_DO ) do
                    for field, value in pairs( value ) do
                        assert( loadstring( "dev = __"..value ) )( )
                        if dev == nil then
                            error( "Unknown device '"..value..
                                "' (__"..value..")." )
                        end
                        mode[ -1 ][ step.A_DO_DI ]:add_dev( dev, group )
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
                        end

                        for field, value in pairs( value ) do --����������.
                            assert( loadstring( "dev = __"..value ) )( )
                            if dev == nil then
                                error( "Unknown device '"..value..
                                    "' (__"..value..")." )
                            end

                            mode[ -1 ][ step.A_WASH ]:add_dev( dev, group )
                        end
                    end
                    group = group + 1
                end
            end

            --����.
            if value.steps ~= nil then
                local steps_count = #value.steps

                for fields, value in ipairs( value.steps ) do
                    local time_param_n = value.time_param_n or 0
                    local next_step_n = value.next_step_n or 0

                    mode:add_step( value.name, next_step_n, time_param_n )

                    local step_n = fields

                    process_dev(  mode, step_n, step.A_ON,  value.opened_devices )
                    process_dev(  mode, step_n, step.A_OFF, value.closed_devices )

                    process_seat( mode, step_n, step.A_UPPER_SEATS_ON,
                        value.opened_upper_seat_v, i_mix_proof.ST_UPPER_SEAT )
                    process_seat( mode, step_n, step.A_LOWER_SEATS_ON,
                        value.opened_lower_seat_v, i_mix_proof.ST_LOWER_SEAT )
                end
            end
        end --for fields, value in ipairs( value.modes ) do

    end --for fields, value in ipairs( tech_objects ) do

    return 0
end
