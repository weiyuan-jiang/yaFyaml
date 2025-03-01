#include "string_handling.h"
module fy_AbstractNode
   use fy_KeywordEnforcer
   implicit none
   private

   public :: AbstractNode

   type, abstract :: AbstractNode
   contains
      procedure(i_size), deferred :: size

      ! accessors to sub-nodes
      procedure(I_at_multi_selector), deferred :: at_multi_selector
      generic :: at => at_multi_selector
      procedure(I_of_multi_selector), deferred :: of_multi_selector
      generic :: of => of_multi_selector
      procedure(I_has), deferred :: has

      procedure(I_get_logical),   deferred :: get_logical
      procedure(I_get_logical_1d),   deferred :: get_logical_1d
      procedure(I_get_string),    deferred :: get_string
      procedure(I_get_integer32), deferred :: get_integer32
      procedure(I_get_integer32_1d), deferred :: get_integer32_1d
      procedure(I_get_integer64), deferred :: get_integer64
      procedure(I_get_integer64_1d), deferred :: get_integer64_1d

      procedure(I_get_real32),    deferred :: get_real32
      procedure(I_get_real32_1d),    deferred :: get_real32_1d
      procedure(I_get_real64),    deferred :: get_real64
      procedure(I_get_real64_1d),    deferred :: get_real64_1d

      generic :: get => get_logical, get_logical_1d
      generic :: get => get_string
      generic :: get => get_integer32, get_integer32_1d
      generic :: get => get_integer64, get_integer64_1d
      generic :: get => get_real32, get_real32_1d
      generic :: get => get_real64, get_real64_1d

      procedure(I_assign_to_logical),   pass(this), deferred :: assign_to_logical
      procedure(I_assign_to_string),    pass(this), deferred :: assign_to_string
      procedure(I_assign_to_integer32), pass(this), deferred :: assign_to_integer32
      procedure(I_assign_to_integer64), pass(this), deferred :: assign_to_integer64
      procedure(I_assign_to_real32),    pass(this), deferred :: assign_to_real32
      procedure(I_assign_to_real64),    pass(this), deferred :: assign_to_real64
      generic :: assignment(=) => assign_to_logical
      generic :: assignment(=) => assign_to_string
      generic :: assignment(=) => assign_to_integer32
      generic :: assignment(=) => assign_to_integer64
      generic :: assignment(=) => assign_to_real32
      generic :: assignment(=) => assign_to_real64

      ! using YAML terminology
      procedure(I_is), deferred, nopass :: is_sequence
      procedure(I_is), deferred, nopass :: is_mapping
      procedure(I_is), deferred, nopass :: is_scalar
      procedure(I_is), deferred, nopass :: is_bool
      procedure(I_is), deferred, nopass :: is_string
      procedure(I_is), deferred, nopass :: is_int
      procedure(I_is), deferred, nopass :: is_float

      procedure(I_write_formatted), deferred :: write_formatted
      generic :: write(formatted) => write_formatted
      procedure(I_write_node_formatted), deferred :: write_node_formatted

      ! "<"
      ! Necessary to support map container with *Node keys.
      procedure(I_less_than), deferred :: less_than
      generic :: operator(<) => less_than

   end type AbstractNode

#define SELECTORS s1, s2, s3, s4, s5, s6, s7, s8, s9
#define OPT_SELECTORS s2, s3, s4, s5, s6, s7, s8, s9
   abstract interface

      integer function i_size(this)
         import AbstractNode
         class(AbstractNode), intent(in) :: this
      end function i_size
      
      function I_of_multi_selector(this, SELECTORS) result(node_ptr)
         import AbstractNode
         implicit none
         class(AbstractNode), pointer :: node_ptr
         class(AbstractNode), target, intent(in) :: this
         class(*), optional, intent(in) :: SELECTORS
      end function I_of_multi_selector

      logical function I_has(this, SELECTORS) result(has)
         import AbstractNode
         implicit none
         class(AbstractNode), intent(in) :: this
         class(*), intent(in) :: s1 ! at least one selector required here
         class(*), optional, intent(in) :: OPT_SELECTORS
      end function I_has


      function I_at_multi_selector(this, SELECTORS, &
           & unusable, found, err_msg, rc) result(node_ptr)
         use fy_KeywordEnforcer
         import AbstractNode
         implicit none
         class(AbstractNode), pointer :: node_ptr
         class(AbstractNode), target, intent(in) :: this
         class(*), optional, intent(in) :: SELECTORS
         class(KeywordEnforcer), optional, intent(in) :: unusable
         logical, optional, intent(out) :: found
         STRING_DUMMY, optional, intent(inout) :: err_msg
         integer, optional, intent(out) :: rc
      end function I_at_multi_selector


      subroutine I_get_logical(this, value, SELECTORS, unusable, err_msg, rc)
         use fy_KeywordEnforcer
         import AbstractNode
         implicit none
         class(AbstractNode), target, intent(in) :: this
         logical, intent(inout) :: value
         class(*), optional, intent(in) :: SELECTORS
         class(KeywordEnforcer), optional, intent(in) :: unusable
         STRING_DUMMY, optional, intent(inout) :: err_msg
         integer, optional, intent(out) :: rc
      end subroutine I_get_logical

      subroutine I_get_logical_1d(this, values, SELECTORS, unusable, err_msg, rc)
         use fy_KeywordEnforcer
         import AbstractNode
         implicit none
         class(AbstractNode), target, intent(in) :: this
         logical, allocatable, intent(inout) :: values(:)
         class(*), optional, intent(in) :: SELECTORS
         class(KeywordEnforcer), optional, intent(in) :: unusable
         STRING_DUMMY, optional, intent(inout) :: err_msg
         integer, optional, intent(out) :: rc
      end subroutine I_get_logical_1d


      subroutine I_get_string(this, value, SELECTORS, unusable, err_msg, rc)
         use fy_KeywordEnforcer
         import AbstractNode
         implicit none
         class(AbstractNode), target, intent(in) :: this
         character(:), allocatable, intent(inout) :: value
         class(*), optional, intent(in) :: SELECTORS
         class(KeywordEnforcer), optional, intent(in) :: unusable
         STRING_DUMMY, optional, intent(inout) :: err_msg
         integer, optional, intent(out) :: rc
      end subroutine I_get_string

      subroutine I_get_string_1d(this, values, SELECTORS, unusable, err_msg, rc)
         use fy_KeywordEnforcer
         import AbstractNode
         implicit none
         class(AbstractNode), target, intent(in) :: this
         character(:), allocatable, intent(inout) :: values(:)
         class(*), optional, intent(in) :: SELECTORS
         class(KeywordEnforcer), optional, intent(in) :: unusable
         STRING_DUMMY, optional, intent(inout) :: err_msg
         integer, optional, intent(out) :: rc
      end subroutine I_get_string_1d


      subroutine I_get_integer32(this, value, SELECTORS, unusable, err_msg, rc)
         use fy_KeywordEnforcer
         use, intrinsic :: iso_fortran_env, only: INT32
         import AbstractNode
         implicit none
         class(AbstractNode), target, intent(in) :: this
         integer(kind=INT32), intent(inout) :: value
         class(*), optional, intent(in) :: SELECTORS
         class(KeywordEnforcer), optional, intent(in) :: unusable
         STRING_DUMMY, optional, intent(inout) :: err_msg
         integer, optional, intent(out) :: rc
      end subroutine I_get_integer32

      subroutine I_get_integer32_1d(this, values, SELECTORS, unusable, err_msg, rc)
         use fy_KeywordEnforcer
         use, intrinsic :: iso_fortran_env, only: INT32
         import AbstractNode
         implicit none
         class(AbstractNode), target, intent(in) :: this
         integer(kind=INT32), allocatable, intent(inout) :: values(:)
         class(*), optional, intent(in) :: SELECTORS
         class(KeywordEnforcer), optional, intent(in) :: unusable
         STRING_DUMMY, optional, intent(inout) :: err_msg
         integer, optional, intent(out) :: rc
      end subroutine I_get_integer32_1d


      subroutine I_get_integer64(this, value, SELECTORS, unusable, err_msg, rc)
         use fy_KeywordEnforcer
         use, intrinsic :: iso_fortran_env, only: INT64
         import AbstractNode
         implicit none
         class(AbstractNode), target, intent(in) :: this
         integer(kind=INT64), intent(inout) :: value
         class(*), optional, intent(in) :: SELECTORS
         class(KeywordEnforcer), optional, intent(in) :: unusable
         STRING_DUMMY, optional, intent(inout) :: err_msg
         integer, optional, intent(out) :: rc
      end subroutine I_get_integer64

      subroutine I_get_integer64_1d(this, values, SELECTORS, unusable, err_msg, rc)
         use fy_KeywordEnforcer
         use, intrinsic :: iso_fortran_env, only: INT64
         import AbstractNode
         implicit none
         class(AbstractNode), target, intent(in) :: this
         integer(kind=INT64), allocatable, intent(inout) :: values(:)
         class(*), optional, intent(in) :: SELECTORS
         class(KeywordEnforcer), optional, intent(in) :: unusable
         STRING_DUMMY, optional, intent(inout) :: err_msg
         integer, optional, intent(out) :: rc
      end subroutine I_get_integer64_1d


      subroutine I_get_real32(this, value, SELECTORS, unusable, err_msg, rc)
         use fy_KeywordEnforcer
         use, intrinsic :: iso_fortran_env, only: REAL32
         import AbstractNode
         implicit none
         class(AbstractNode), target, intent(in) :: this
         real(kind=REAL32), intent(inout) :: value
         class(*), optional, intent(in) :: SELECTORS
         class(KeywordEnforcer), optional, intent(in) :: unusable
         STRING_DUMMY, optional, intent(inout) :: err_msg
         integer, optional, intent(out) :: rc
      end subroutine I_get_real32

      subroutine I_get_real32_1d(this, values, SELECTORS, unusable, err_msg, rc)
         use fy_KeywordEnforcer
         use, intrinsic :: iso_fortran_env, only: REAL32
         import AbstractNode
         implicit none
         class(AbstractNode), target, intent(in) :: this
         real(kind=REAL32), allocatable, intent(inout) :: values(:)
         class(*), optional, intent(in) :: SELECTORS
         class(KeywordEnforcer), optional, intent(in) :: unusable
         STRING_DUMMY, optional, intent(inout) :: err_msg
         integer, optional, intent(out) :: rc
      end subroutine I_get_real32_1d


      subroutine I_get_real64(this, value, SELECTORS, unusable, err_msg, rc)
         use fy_KeywordEnforcer
         use, intrinsic :: iso_fortran_env, only: REAL64
         import AbstractNode
         implicit none
         class(AbstractNode), target, intent(in) :: this
         real(kind=REAL64), intent(inout) :: value
         class(*), optional, intent(in) :: SELECTORS
         class(KeywordEnforcer), optional, intent(in) :: unusable
         STRING_DUMMY, optional, intent(inout) :: err_msg
         integer, optional, intent(out) :: rc
      end subroutine I_get_real64

      subroutine I_get_real64_1d(this, values, SELECTORS, unusable, err_msg, rc)
         use fy_KeywordEnforcer
         use, intrinsic :: iso_fortran_env, only: REAL64
         import AbstractNode
         implicit none
         class(AbstractNode), target, intent(in) :: this
         real(kind=REAL64), allocatable, intent(inout) :: values(:)
         class(*), optional, intent(in) :: SELECTORS
         class(KeywordEnforcer), optional, intent(in) :: unusable
         STRING_DUMMY, optional, intent(inout) :: err_msg
         integer, optional, intent(out) :: rc
      end subroutine I_get_real64_1d


      subroutine I_assign_to_logical(flag, this)
         import AbstractNode
         implicit none
         logical, intent(inout) :: flag
         class(AbstractNode), intent(in) :: this
      end subroutine I_assign_to_logical


      subroutine I_assign_to_string(string, this)
         import AbstractNode
         implicit none
         character(:), allocatable, intent(inout) :: string
         class(AbstractNode), intent(in) :: this
      end subroutine I_assign_to_string

      subroutine I_assign_to_integer32(i32, this)
         use, intrinsic :: iso_fortran_env, only: INT32
         import AbstractNode
         implicit none
         integer(kind=INT32), intent(inout) :: i32
         class(AbstractNode), intent(in) :: this
      end subroutine I_assign_to_integer32

      subroutine I_assign_to_integer64(i64, this)
         use, intrinsic :: iso_fortran_env, only: INT64
         import AbstractNode
         implicit none
         integer(kind=INT64), intent(inout) :: i64
         class(AbstractNode), intent(in) :: this
      end subroutine I_assign_to_integer64

      subroutine I_assign_to_real32(r32, this)
         use, intrinsic :: iso_fortran_env, only: REAL32
         import AbstractNode
         implicit none
         real(kind=REAL32), intent(inout) :: r32
         class(AbstractNode), intent(in) :: this
      end subroutine I_assign_to_real32

      subroutine I_assign_to_real64(r64, this)
         use, intrinsic :: iso_fortran_env, only: REAL64
         import AbstractNode
         implicit none
         real(kind=REAL64), intent(inout) :: r64
         class(AbstractNode), intent(in) :: this
      end subroutine I_assign_to_real64

      pure logical function I_is() result(is)
         import AbstractNode
      end function I_is

      logical function I_less_than(a, b)
         import AbstractNode
         implicit none
         class(AbstractNode), intent(in) :: a
         class(AbstractNode), intent(in) :: b
      end function I_less_than

      subroutine i_write_formatted(this, unit, iotype, v_list, iostat, iomsg)
         import AbstractNode
         class(AbstractNode), intent(in) :: this
         integer, intent(in) :: unit
         character(*), intent(in) :: iotype
         integer, intent(in) :: v_list(:)
         integer, intent(out) :: iostat
         character(*), intent(inout) :: iomsg
      end subroutine i_write_formatted

      subroutine i_write_node_formatted(this, unit, iotype, v_list, iostat, iomsg)
         import AbstractNode
         class(AbstractNode), intent(in) :: this
         integer, intent(in) :: unit
         character(*), intent(in) :: iotype
         integer, intent(in) :: v_list(:)
         integer, intent(out) :: iostat
         character(*), intent(inout) :: iomsg
      end subroutine i_write_node_formatted

   end interface


end module fy_AbstractNode
