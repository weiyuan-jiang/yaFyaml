#include "error_handling.h"
#include "string_handling.h"
module fy_FloatNode
   use, intrinsic :: iso_fortran_env, only: REAL32, REAL64
   use fy_AbstractNode
   use fy_BaseNode
   use fy_ErrorCodes
   use fy_ErrorHandling
   use fy_keywordEnforcer
   implicit none
   private

   public :: FloatNode
   public :: to_float

   type, extends(BaseNode) :: FloatNode
      private
      real(kind=REAL64) :: value = -huge(1._REAL64)
   contains
      procedure, nopass :: is_float
      procedure, nopass :: is_scalar
      procedure, pass(this) :: assign_to_real32
      procedure, pass(this) :: assign_to_real64
      procedure :: less_than
      procedure :: write_node_formatted
   end type FloatNode

   interface
      module function less_than(a,b)
         implicit none
         logical :: less_than
         class(FloatNode), intent(in) :: a
         class(AbstractNode), intent(in) :: b
      end function less_than
   end interface

   interface FloatNode
      module procedure new_FloatNode_r32
      module procedure new_FloatNode_r64
   end interface FloatNode

contains

   pure logical function is_float() result(is)
      is = .true.
   end function is_float

   pure logical function is_scalar() result(is)
      is = .true.
   end function is_scalar

   function new_FloatNode_r32(r32) result(node)
      type(FloatNode) :: node
      real(kind=REAL32), intent(in) :: r32
      node%value = r32
   end function new_FloatNode_r32

   function new_FloatNode_r64(r64) result(node)
      type(FloatNode) :: node
      real(kind=REAL64), intent(in) :: r64
      node%value = r64
   end function new_FloatNode_r64


   subroutine assign_to_real32(r32, this)
      use, intrinsic :: ieee_arithmetic, only: ieee_value, &
           & IEEE_POSITIVE_INF, IEEE_NEGATIVE_INF, IEEE_QUIET_NAN
      real(kind=REAL32), intent(inout) :: r32
      class(FloatNode), intent(in) :: this

      if (abs(this%value) <= huge(1._REAL32)) then
         r32 = this%value
      elseif (this%value < -huge(1._REAL32)) then
         r32 = ieee_value(r32,  IEEE_NEGATIVE_INF)
      elseif (this%value > huge(1._REAL32)) then
         r32 = ieee_value(r32,  IEEE_POSITIVE_INF)
      else ! must be NaN
         r32 = ieee_value(r32,  IEEE_QUIET_NAN)
      end if

   end subroutine assign_to_real32
      

   subroutine assign_to_real64(r64, this)
      real(kind=REAL64), intent(inout) :: r64
      class(FloatNode), intent(in) :: this

      r64 = this%value

   end subroutine assign_to_real64


   function to_float(this, unusable, err_msg, rc) result(ptr)
      real(kind=REAL64), pointer :: ptr
      class(AbstractNode), target, intent(in) :: this
      class(KeywordEnforcer), optional, intent(in) :: unusable
      STRING_DUMMY, optional, intent(inout) :: err_msg
      integer, optional, intent(out) :: rc

      select type (this)
      type is (FloatNode)
         ptr => this%value
      class default
         ptr => null()
         __FAIL2__(YAFYAML_TYPE_MISMATCH)
      end select

      __RETURN__(YAFYAML_SUCCESS)
   end function to_float

   subroutine write_node_formatted(this, unit, iotype, v_list, iostat, iomsg)
      class(FloatNode), intent(in) :: this
      integer, intent(in) :: unit
      character(*), intent(in) :: iotype
      integer, intent(in) :: v_list(:)
      integer, intent(out) :: iostat
      character(*), intent(inout) :: iomsg
      

      write(unit,'(g0)',iostat=iostat) this%value
      
   end subroutine write_node_formatted

end module fy_FloatNode
