require "webpacker/compiler"
class Webpacker::Compiler
  private

    def run_webpack
      logger.info "Compiling…"

      stdout, sterr, status = Dir.chdir(Rails.root) do
        Open3.capture3(webpack_env, "#{RbConfig.ruby} ./bin/webpack")
      end

      if status.success?
        logger.info "Compiled all packs in #{config.public_output_path}"
      else
        logger.error "Compilation failed:\n#{sterr}\n#{stdout}"
      end

      status.success?
    end
end
