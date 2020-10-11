#include <iostream>
#include <memory>

class A {
public:
    static void *operator new(size_t size) {
        std::cout << "operator new!" << std::endl;
        return ::operator new(size);
    }

    static void operator delete(void *p, size_t size) {
        std::cout << "operator delete!" << std::endl;
        return ::operator delete(p);
    }
};

template <class T>
class TAllocator {
public:
    template <class U>
    friend class TAllocator;

    using value_type = T;

    using alloc_new = void* (*)(size_t);
    using alloc_delete = void (*)(void*, size_t);

    TAllocator() {
        alloc_new_ = T::operator new;
        alloc_delete_ = T::operator delete;
    }

    TAllocator(alloc_new operator_new,
               alloc_delete operator_delete)
        : alloc_new_(operator_new), alloc_delete_(operator_delete) {}

    template<class U>
    TAllocator(const TAllocator<U>& other)
        : alloc_new_(other.alloc_new_),
          alloc_delete_(other.alloc_delete_) {}

    T* allocate(size_t n) {
        return static_cast<T*>(alloc_new_(n * sizeof(T)));
    }

    void deallocate(T* p, size_t n) {
        alloc_delete_(p, n * sizeof(T));
    }

private:
    alloc_new alloc_new_;
    alloc_delete alloc_delete_;
};

int main()
{
    TAllocator<A> alloc;
    auto sp1 = std::make_shared<A>();
    auto sp2 = std::allocate_shared<A>(alloc);
}
