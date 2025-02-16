#include "error_handling.h"
#include "string_handling.h"
module fy_IntNode
   use, intrinsic :: iso_fortran_env, only: INT32, INT64
   use fy_AbstractNode
   use fy_BaseNode
   use fy_ErrorCodes
   use fy_ErrorHandling
   use fy_keywordEnforcer
   implicit none
   private

   public :: IntNode
   public :: to_int

   type, extends(BaseNode) :: IntNode
      private
      integer(kind=INT64) :: value = -huge(1_INT64)
   contains
      procedure, nopass :: is_int
      procedure, nopass :: is_scalar
      procedure, pass(this) :: assign_to_integer32
      procedure, pass(this) :: assign_to_integer64
      procedure :: less_than
      procedure :: write_node_formatted
   end type IntNode

   interface
      module function less_than(a,b)
         implicit none
         logical :: less_than
         class(IntNode), intent(in) :: a
         class(AbstractNode), intent(in) :: b
      end function less_than
   end interface

   interface IntNode
      module procedure new_IntNode_i32
      module procedure new_IntNode_i64
   end interface IntNode

contains

   pure logical function is_int() result(is)
      is = .true.
   end function is_int

   pure logical function is_scalar() result(is)
      is = .true.
   end function is_scalar

   function new_IntNode_i32(i32) result(node)
      type(IntNode) :: node
      integer(kind=INT32), intent(in) :: i32
      node%value = i32
   end function new_IntNode_i32

   function new_IntNode_i64(i64) result(node)
      type(IntNode) :: node
      integer(kind=INT64), intent(in) :: i64
      node%value = i64
   end function new_IntNode_i64

   subroutine assign_to_integer32(i32, this)
      integer(kind=INT32), intent(inout) :: i32
      class(IntNode), intent(in) :: this

      if (abs(this%value) <= huge(1_INT32)) then
         i32 = this%value
      else
         ! unchanged
         i32 = -huge(1_INT32)
      end if
   end subroutine assign_to_integer32
      

   subroutine assign_to_integer64(i64, this)
      integer(kind=INT64), intent(inout) :: i64
      class(IntNode), intent(in) :: this

      i64 = this%value

   end subroutine assign_to_integer64


   function to_int(this, unusable, err_msg, rc) result(ptr)
      integer(kind=INT64), pointer :: ptr
      class(AbstractNode), target, intent(in) :: this
      class(KeywordEnforcer), optional, intent(in) :: unusable
      STRING_DUMMY, optional, intent(inout) :: err_msg
      integer, optional, intent(out) :: rc

      select type (this)
      type is (IntNode)
         ptr => this%value
      class default
         ptr => null()
         __FAIL2__(YAFYAML_TYPE_MISMATCH)
      end select

      __RETURN__(YAFYAML_SUCCESS)
   end function to_int

   subroutine write_node_formatted(this, unit, iotype, v_list, iostat, iomsg)
      class(IntNode), intent(in) :: this
      integer, intent(in) :: unit
      character(*), intent(in) :: iotype
      integer, intent(in) :: v_list(:)
      integer, intent(out) :: iostat
      character(*), intent(inout) :: iomsg
      
      write(unit,'(i0)',iostat=iostat) this%value
      
   end subroutine write_node_formatted

end module fy_IntNode
