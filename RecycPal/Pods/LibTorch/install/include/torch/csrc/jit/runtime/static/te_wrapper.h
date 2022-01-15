#pragma once

#include <torch/csrc/jit/tensorexpr/codegen.h>
#include <torch/csrc/jit/tensorexpr/ir.h>
#include <torch/csrc/jit/tensorexpr/ir_simplifier.h>
#include <torch/csrc/jit/tensorexpr/llvm_codegen.h>
#include <torch/csrc/jit/tensorexpr/loopnest.h>

namespace torch {
namespace jit {

class TEWrapper {
 public:
  TEWrapper() = default;
  void call(const std::vector<void*>& args);
  bool supports(const at::Tensor& t);
#ifdef TORCH_ENABLE_LLVM
  void update(std::unique_ptr<tensorexpr::LLVMCodeGen>&& cg_);
#endif

 private:
#ifdef TORCH_ENABLE_LLVM
  std::unique_ptr<tensorexpr::LLVMCodeGen> cg;
#endif
};

std::shared_ptr<TEWrapper> createLogit();
std::shared_ptr<TEWrapper> createRelu();
std::shared_ptr<TEWrapper> createTanh();
std::shared_ptr<TEWrapper> createSigmoid();

} // namespace jit
} // namespace torch
